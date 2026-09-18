//+------------------------------------------------------------------+
//|                                                     requests.mqh |
//|                                          Copyright 2023, Omegafx |
//|                 https://www.mql5.com/en/users/omegajoctan/seller |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Omegafx"
#property link      "https://www.mql5.com/en/users/omegajoctan/seller"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
#include "jason.mqh"
#include <Arrays\ArrayChar.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct CResponse
  {
   int               status_code; // HTTP status code (e.g., 200, 404)
   string            text; // Raw response body as string

   //CJAVal            json; // Parses response as JSON
   uchar             content[]; // Raw bytes of the response
   string            headers; // Dictionary of response headers
   string            cookies; // Cookies set by the server
   string            url; // Final URL after redirects
   bool              ok;     // True if status_code < 400
   uint              elapsed; // Time taken for the response in ms
   string            reason; // Text reason (e.g., "OK", "Not Found")
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CSession
  {
protected:

   string            WebStatusText(int code);
   /**
    * Base 64 is an encoding scheme that converts binary data into text
    * format so that encoded textual data can be easily transported over
    * network un-corrupted and without any data loss. Base64 is used
    * commonly in a number of applications including email via MIME, and
    * storing complex data in XML.
    */

   bool              CharBase64Encode(const uchar &in[], uchar &out[]);
   bool              CharBase64Decode(const uchar &in[], uchar &out[]);

   string            StringTrim(string s)
     {
      StringTrimLeft(s);
      StringTrimRight(s);
      return s;
     }

   string            UpdateHeader(const string headers, const string key, const string value);
   string            UpdateHeader(const string headers, const string new_header_key_value_pair);
   string            GuessContentType(string filename);

   void              CArray2Array(const CArrayChar &c_array, char &out_array[])
     {
      int size = c_array.Total();

      ArrayResize(out_array, size);
      for(int i = 0; i < size; i++)
         out_array[i] = c_array.At(i);
     }

   string            GetFileName(string base_filename)
     {
      string basename = base_filename;
      int pos = StringFind(base_filename, "\\", StringLen(base_filename) - 1);

      if(pos >= 0)
         basename = StringSubstr(base_filename, pos + 1);
      pos = StringFind(basename, "/", StringLen(basename) - 1); // handle Unix-style paths

      if(pos >= 0)
         basename = StringSubstr(basename, pos + 1);

      return basename;
     }


   string            m_headers;
   string            m_cookies;
   uint              m_timeout;

public:

                     CSession(const string headers, const string cookies = "", const uint timeout = 5000); // Provides headers cookies persistance
                    ~CSession(void);

   void              SetCookie(const string cookie)
     {
      if(StringLen(m_cookies) > 0)
         m_cookies += "; ";
      m_cookies += cookie;
     }

   void              ClearCookies() {    m_cookies = "";     }
   void              SetBasicAuth(const string username, const string password);

   static string     URLEncode(const string value);
   static string     BuildUrlWithParams(string base_url, const string &keys[], const string &values[]);

   //---

   CResponse         request(const string method, const string url, const string data, const string &files[]);
   CResponse         request(const string method, const string url, const string data);

   // High-level request helpers
   CResponse         get(const string url);

   CResponse         post(const string url, const string data, const string &files[]);
   CResponse         post(const string url, const string data);

   CResponse         put(const string url, const string data, const string &files[]);
   CResponse         put(const string url, const string data);

   CResponse         patch(const string url, const string data = "");
   CResponse         delete_(const string url);

   static string     Base64Encode(const string text);
   static string     Base64Decode(const string text);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSession::CSession(const string headers, const string cookies = "", const uint timeout = 5000):
   m_headers(headers),
   m_cookies(cookies),
   m_timeout(m_timeout)
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CSession::~CSession(void)
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CResponse CSession::request(const string method,
                            const string url,
                            const string data,
                            const string &files[])
  {
   string final_headers = m_headers;
   CResponse resp;

   bool has_files = (ArraySize(files) > 0);

// Detect content type
   string content_type = "";
   int idx = StringFind(final_headers, "Content-Type:");
   if(idx >= 0)
     {
      int start = idx + 13;
      int end   = StringFind(final_headers, "\r\n", start);
      content_type = StringSubstr(final_headers, start, end - start);
      StringTrimLeft(content_type);
      StringTrimRight(content_type);
     }

// Decide how to send
   bool use_json = false;
   bool use_multipart = false;

   if(StringLen(content_type) > 0)
     {
      if(StringFind(content_type, "application/json") >= 0)
         use_json = true;
      else
         if(StringFind(content_type, "multipart/form-data") >= 0)
            use_multipart = true;
     }
   else
     {
      // fallback heuristics
      string temp_data = data;
      if(StringLen(data) > 0 && (StringSubstr(data, StringTrimLeft(temp_data), 1) == "{" ||
                                 StringSubstr(data, StringTrimLeft(temp_data), 1) == "["))
         use_json = true;
      else
         if(has_files)
            use_multipart = true;
     }

// -------- JSON CASE -------

   CArrayChar body;
   string boundary = "----MQL5Boundary" + IntegerToString(GetTickCount());

   if(use_json)
     {
      final_headers = UpdateHeader(final_headers, "Content-Type", "application/json");

      CJAVal js(NULL, jtOBJ);
      if(!js.Deserialize(data, CP_UTF8))
        {
         printf("line: %d Failed to parse JSON data!", __LINE__);
         DebugBreak();
         return resp;
        }

      // encode files into Base64 inside JSON
      if(has_files)
        {
         CJAVal attachments(NULL, jtARRAY);
         for(int i = 0; i < ArraySize(files); i++)
           {
            string filepath = files[i];
            string filename = GetFileName(filepath);

            int handle = FileOpen(filepath, FILE_BIN | FILE_READ | FILE_SHARE_READ);
            if(handle == INVALID_HANDLE)
              {
               PrintFormat("Cannot open file: %s Error = %d", filepath, GetLastError());
               continue;
              }

            int size = (int)FileSize(handle);
            uchar file_data[];
            ArrayResize(file_data, size);
            FileReadArray(handle, file_data, 0, size);
            FileClose(handle);

            uchar encoded_chars[];
            CharBase64Encode(file_data, encoded_chars);
            string encoded_str = CharArrayToString(encoded_chars, 0, ArraySize(encoded_chars));

            CJAVal att(NULL, jtOBJ);
            att["filename"] = filename;
            att["data"]     = encoded_str;
            att["mimetype"] = "application/octet-stream";
            attachments.Add(att);
           }
         attachments.m_key = "attachments";
         js.Add(attachments);
        }

      string json_body;
      js.Serialize(json_body);
      char arr[];
      StringToCharArray(json_body, arr, 0, StringLen(json_body), CP_UTF8);
      body.AddArray(arr);
     }

// --- MULTIPART CASE ---
   else
      if(use_multipart)
        {
         final_headers = UpdateHeader(final_headers, "Content-Type", "multipart/form-data; boundary=" + boundary);

         // text fields
         if(StringLen(data) > 0)
           {
            string arr[];
            StringSplit(data, '&', arr);
            for(uint i = 0; i < arr.Size(); i++)
              {
               string key_val[];
               if(StringSplit(arr[i], '=', key_val) == 2)
                 {
                  string part =
                     "--" + boundary + "\r\n" +
                     "Content-Disposition: form-data; name=\"" + key_val[0] + "\"\r\n\r\n" +
                     key_val[1] + "\r\n";

                  char buff[];
                  StringToCharArray(part, buff, 0, StringLen(part), CP_UTF8);
                  body.AddArray(buff);
                 }
              }
           }

         // file attachments
         for(int i = 0; i < ArraySize(files); i++)
           {
            string filepath = files[i];
            string filename = GetFileName(filepath);

            int handle = FileOpen(filepath, FILE_BIN | FILE_READ | FILE_SHARE_READ);
            if(handle == INVALID_HANDLE)
              {
               Print("Cannot open file: ", filepath);
               continue;
              }

            int size = (int)FileSize(handle);
            char file_data[];
            ArrayResize(file_data, size);
            FileReadArray(handle, file_data, 0, size);
            FileClose(handle);

            string header =
               "--" + boundary + "\r\n" +
               "Content-Disposition: form-data; name=\"file\"; filename=\"" + filename + "\"\r\n" +
               "Content-Type: application/octet-stream\r\n\r\n";

            char hdr[];
            StringToCharArray(header, hdr, 0, StringLen(header), CP_UTF8);
            body.AddArray(hdr);
            body.AddArray(file_data);
            body.Add('\r');
            body.Add('\n');
           }

         string closing = "--" + boundary + "--\r\n";
         char closing_arr[];
         StringToCharArray(closing, closing_arr, 0, StringLen(closing), CP_UTF8);
         body.AddArray(closing_arr);
        }
      // ------ FALLBACK: raw string --------
      else
        {
         char arr[];
         StringToCharArray(data, arr, 0, StringLen(data), CP_UTF8);
         body.AddArray(arr);
        }

//-- send a webrequest

   ResetLastError();

   char body_char[];
   CArray2Array(body, body_char);

   char result[];
   string result_headers;
   uint start = GetTickCount();
   int status = WebRequest(method, url, final_headers, m_timeout, body_char, result, result_headers);
   if(status < 0)
     {
      printf("WebRequest failed. Error = %d", GetLastError());
      printf("url: %s\nheaders: %s\nbody: %s\nresult: %s,\nres headers: %s",
             url,
             final_headers,
             CharArrayToString(body_char),
             CharArrayToString(result),
             result_headers);
     }

   resp.elapsed = GetTickCount() - start;
   resp.status_code = status;
   resp.text = CharArrayToString(result);
   resp.headers = result_headers;
   resp.url = url;
   resp.ok = (status >= 200 && status < 400);
   resp.reason = WebStatusText(status);
   ArrayCopy(resp.content, result);

   return resp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CResponse CSession::request(const string method, const string url, const string data)
  {
   string files[];
   return request(method, url, data, files);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CSession::WebStatusText(int code)
  {
   string reason = "";
   switch(code)
     {
      case 200:
         reason =  "OK";
         break;
      case 201:
         reason = "Created";
         break;
      case 400:
         reason = "Bad Request";
         break;
      case 401:
         reason = "Unauthorized";
         break;
      case 403:
         reason = "Forbidden";
         break;
      case 404:
         reason = "Not Found";
         break;
      case 500:
         reason = "Internal Server Error";
         break;
      default:
         reason = "HTTP " + IntegerToString(code);
         break;
     }

   return reason;
  }
//+------------------------------------------------------------------+
//|         Sets or replaces default headers                         |
//+------------------------------------------------------------------+
string CSession::UpdateHeader(const string headers, const string key, const string value)
  {
   string res_headers = "";
   if(StringFind(headers, key + ":") >= 0)
     {
      // Replace existing header
      int start = StringFind(headers, key + ":");
      int end = StringFind(headers, "\r\n", start);

      if(end == -1)
         end = StringLen(headers);

      res_headers = StringSubstr(headers, 0, start) +
                    key + ": " + value + "\r\n" +
                    StringSubstr(headers, end + 2);
     }
   else
     {
      // Add new header
      res_headers += key + ": " + value + "\r\n";
     }

   return res_headers;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CSession::UpdateHeader(const string headers, const string new_header_key_value_pair)
  {
   string key = "";
   string value = "";

// Split the input string into key and value based on the first colon
   int colon_index = StringFind(new_header_key_value_pair, ":");
   if(colon_index > -1)
     {
      key = StringTrim(StringSubstr(new_header_key_value_pair, 0, colon_index));
      value = StringTrim(StringSubstr(new_header_key_value_pair, colon_index + 1));
     }
   else
     {
      // Invalid format; return headers unmodified
      return headers;
     }

   string res_headers = headers;
   int start = StringFind(headers, key + ":");
   if(start >= 0)
     {
      // Replace existing header
      int end = StringFind(headers, "\r\n", start);
      if(end == -1)
         end = StringLen(headers);

      res_headers = StringSubstr(headers, 0, start) +
                    key + ": " + value + "\r\n" +
                    StringSubstr(headers, end + 2);
     }
   else
     {
      // Add new header
      res_headers += key + ": " + value + "\r\n";
     }

   return res_headers;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CSession::SetBasicAuth(const string username, const string password)
  {
   string credentials = username + ":" + password;
   string encoded = Base64Encode(credentials); //Encode the credentials

   m_headers = UpdateHeader(m_headers, "Authorization", "Basic " + encoded); //Update HTTP headers with the authentication information
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CSession::GuessContentType(string filename)
  {
   StringToLower(filename); // Normalize for case-insensitivity

   if(StringFind(filename, ".txt")   >= 0)
      return "text/plain";
   if(StringFind(filename, ".json")  >= 0)
      return "application/json";
   if(StringFind(filename, ".xml")   >= 0)
      return "application/xml";
   if(StringFind(filename, ".csv")   >= 0)
      return "text/csv";
   if(StringFind(filename, ".html")  >= 0)
      return "text/html";
   if(StringFind(filename, ".htm")   >= 0)
      return "text/html";

//--- Images
   if(StringFind(filename, ".png")   >= 0)
      return "image/png";
   if(StringFind(filename, ".jpg")   >= 0 || StringFind(filename, ".jpeg") >= 0)
      return "image/jpeg";
   if(StringFind(filename, ".gif")   >= 0)
      return "image/gif";
   if(StringFind(filename, ".bmp")   >= 0)
      return "image/bmp";
   if(StringFind(filename, ".webp")  >= 0)
      return "image/webp";
   if(StringFind(filename, ".ico")   >= 0)
      return "image/x-icon";
   if(StringFind(filename, ".svg")   >= 0)
      return "image/svg+xml";

//--- Audio
   if(StringFind(filename, ".mp3")   >= 0)
      return "audio/mpeg";
   if(StringFind(filename, ".wav")   >= 0)
      return "audio/wav";
   if(StringFind(filename, ".ogg")   >= 0)
      return "audio/ogg";

//--- Video
   if(StringFind(filename, ".mp4")   >= 0)
      return "video/mp4";
   if(StringFind(filename, ".avi")   >= 0)
      return "video/x-msvideo";
   if(StringFind(filename, ".mov")   >= 0)
      return "video/quicktime";
   if(StringFind(filename, ".webm")  >= 0)
      return "video/webm";
   if(StringFind(filename, ".mkv")   >= 0)
      return "video/x-matroska";

//--- Applications
   if(StringFind(filename, ".pdf")   >= 0)
      return "application/pdf";
   if(StringFind(filename, ".zip")   >= 0)
      return "application/zip";
   if(StringFind(filename, ".gz")    >= 0)
      return "application/gzip";
   if(StringFind(filename, ".tar")   >= 0)
      return "application/x-tar";
   if(StringFind(filename, ".rar")   >= 0)
      return "application/vnd.rar";
   if(StringFind(filename, ".7z")    >= 0)
      return "application/x-7z-compressed";
   if(StringFind(filename, ".exe")   >= 0)
      return "application/octet-stream";
   if(StringFind(filename, ".apk")   >= 0)
      return "application/vnd.android.package-archive";

//--- Microsoft Office
   if(StringFind(filename, ".doc")   >= 0)
      return "application/msword";
   if(StringFind(filename, ".docx")  >= 0)
      return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
   if(StringFind(filename, ".xls")   >= 0)
      return "application/vnd.ms-excel";
   if(StringFind(filename, ".xlsx")  >= 0)
      return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
   if(StringFind(filename, ".ppt")   >= 0)
      return "application/vnd.ms-powerpoint";
   if(StringFind(filename, ".pptx")  >= 0)
      return "application/vnd.openxmlformats-officedocument.presentationml.presentation";

   return "application/octet-stream"; // Default fallback
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CSession::URLEncode(const string value)
  {
   uchar bytes[];
   StringToCharArray(value, bytes, 0, StringLen(value), CP_UTF8);

   string encoded = "";
   for(int i = 0; i < ArraySize(bytes); ++i)
     {
      uchar c = bytes[i];
      if((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') ||
         c == '-' || c == '_' || c == '.' || c == '~')
        {
         encoded += CharToString(c);
        }
      else
         if(c == ' ')
           {
            encoded += "+";
           }
         else
           {
            encoded += StringFormat("%%%02X", c);
           }
     }
   return encoded;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CSession::BuildUrlWithParams(string base_url, const string &keys[], const string &values[])
  {
   if(keys.Size() != values.Size())
     {
      printf("func=%s line=%d, Failed. Keys and values array sizes dimensional mismatch", __FUNCTION__, __LINE__);
      return "";
     }

//---

   string query = "";
   for(int i = 0; i < ArraySize(keys); ++i)
     {
      if(i > 0)
         query += "&";
      query += URLEncode(keys[i]) + "=" + URLEncode(values[i]);
     }

   return base_url + "?" + query;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CResponse CSession::get(const string url)
  {
   string files[];
   return request("GET", url, "", files);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CResponse CSession::post(const string url, const string data, const string &files[])
  {
   return request("POST", url, data, files);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CResponse CSession::post(const string url, const string data)
  {
   string files[];
   return request("POST", url, data, files);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CResponse CSession::put(const string url, const string data, const string &files[])
  {
   return request("PUT", url, data, files);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CResponse CSession::put(const string url, const string data)
  {
   string files[];
   return request("PUT", url, data, files);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CResponse CSession::patch(const string url, const string data = "")
  {
   string files[];
   return request("PATCH", url, data, files);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CResponse CSession::delete_(const string url)
  {
   string files[];
   return request("DELETE", url, "", files);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSession::CharBase64Encode(const uchar &in[], uchar &out[])
  {
   uchar key[];
   if(CryptEncode(CRYPT_BASE64, in, key, out) < 0)
      return false;

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CSession::CharBase64Decode(const uchar &in[], uchar &out[])
  {
   uchar key[];
   if(CryptDecode(CRYPT_BASE64, in, key, out) < 0)
      return false;

   return true;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string            StringTrim(string s)
  {
   StringTrimLeft(s);
   StringTrimRight(s);
   return s;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CSession::Base64Encode(const string text)
  {
   uchar src[], res[], key[];
   StringToCharArray(text, src, 0, StringLen(text));

//--- encode src[] with BASE64
   if(CryptEncode(CRYPT_BASE64, src, key, res) < 0)
      return "";

   return CharArrayToString(res, 0, res.Size());
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CSession::Base64Decode(const string text)
  {
   uchar src[], res[], key[];

   StringToCharArray(text, src, 0, StringLen(text));

//--- decode src[] with BASE64
   if(CryptDecode(CRYPT_BASE64, src, key, res) < 0)
      return "";

   return CharArrayToString(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
