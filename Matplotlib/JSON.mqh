//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#define del_valid_ptr(ptr) if (CheckPointer(ptr)!=POINTER_INVALID) delete (ptr);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JSON
  {
   class             Object;
   class             Array;
   class             JsonValueItem;

   enum JSONValueItemTypes
     {
      JSONStringType,
      JSONNumberType,
      JSONBoolType,
      JSONObjetType,
      JSONArrayType,
      JSONNullType,
      JSONUndefinedType
     };

public:
   class Object
     {
   public:
                     Object()
        {
         ArrayResize(this._jsonValueItemsArray, 0, 10);
        };
                     Object(string &json)
        {
         ArrayResize(this._jsonValueItemsArray, 0, 10);
         int parceJsonCharCounter = 0;
         bool isSuccess = true;
         JSON::_parseJSONObject(json, parceJsonCharCounter, isSuccess, &this);
         if(!isSuccess)
            this._clearResources();
        };

      JSON::Object*  setProperty(string key, string value)             { return this._setProperty(key, new JsonValueItem(key, value)); }
      JSON::Object*  setProperty(string key, int value)                { return this._setProperty(key, new JsonValueItem(key, value)); }
      JSON::Object*  setProperty(string key, long value)               { return this._setProperty(key, new JsonValueItem(key, value)); }
      JSON::Object*  setProperty(string key, double value)             { return this._setProperty(key, new JsonValueItem(key, value)); }
      JSON::Object*  setProperty(string key, bool value)               { return this._setProperty(key, new JsonValueItem(key, value)); }
      JSON::Object*  setProperty(string key, JSON::Object* value)      { return this._setProperty(key, new JsonValueItem(key, value)); }
      JSON::Object*  setProperty(string key, JSON::Array* value)       { return this._setProperty(key, new JsonValueItem(key, value)); }

      bool           hasValue(string key) const                                 { return this._getPropertyType(key) != JSONUndefinedType; }
      bool           isBoolean(string key) const                                { return this._getPropertyType(key) == JSONBoolType; }
      bool           isNumber(string key) const                                 { return this._getPropertyType(key) == JSONNumberType; }
      bool           isString(string key) const                                 { return this._getPropertyType(key) == JSONStringType; }
      bool           isObject(string key) const                                 { return this._getPropertyType(key) == JSONObjetType; }
      bool           isArray(string key) const                                  { return this._getPropertyType(key) == JSONArrayType; }

      string         getString(string key) const
        {
         const JsonValueItem* item = this._getProperty(key);
         if(item == NULL || item.valueType != JSONStringType)
            return "";
         return item.stringValue;
        }
      double         getNumber(string key) const
        {
         const JsonValueItem* item = this._getProperty(key);
         if(item == NULL || item.valueType != JSONNumberType)
            return 0.0;
         return item.doubleValue;
        }
      bool           getBoolean(string key) const
        {
         const JsonValueItem* item = this._getProperty(key);
         if(item == NULL || item.valueType != JSONBoolType)
            return false;
         return item.booleanValue;
        }
      JSON::Object*  getObject(string key) const
        {
         const JsonValueItem* item = this._getProperty(key);
         if(item == NULL || item.valueType != JSONObjetType)
            return NULL;
         return item.objectValue;
        }
      JSON::Array*   getArray(string key) const
        {
         const JsonValueItem* item = this._getProperty(key);
         if(item == NULL || item.valueType != JSONArrayType)
            return NULL;
         return item.arrayValue;
        }
      void           getKeysToArray(string &array[]) const
        {
         ArrayResize(array, ArraySize(this._jsonValueItemsArray));
         for(int i = 0; i < ArraySize(this._jsonValueItemsArray); array[i] = this._jsonValueItemsArray[i].key, i++);
        }

      string         toString() const
        {
         int arraySize = ArraySize(this._jsonValueItemsArray);
         string result = "";

         for(int i = 0; i < arraySize; i++)
           {
            const JsonValueItem* item = this._jsonValueItemsArray[i];
            result += "\"" + item.key + "\": " + item.toString() + (i < arraySize - 1 ? "," : "");
           }

         return "{" + result + "}";
        }

                    ~Object() { this._clearResources(); }
   private:
      const JsonValueItem* _jsonValueItemsArray[];

      JSON::Object*  _setProperty(string key, const JsonValueItem* valueItem)
        {
         int arraySize = ArraySize(this._jsonValueItemsArray);

         for(int i = 0; i < arraySize; i++)
           {
            if(this._jsonValueItemsArray[i].key == key)
              {
               del_valid_ptr(this._jsonValueItemsArray[i])
               this._jsonValueItemsArray[i] = valueItem;
               return &this;
              }
           }

         ArrayResize(this._jsonValueItemsArray, arraySize + 1, 10);
         this._jsonValueItemsArray[arraySize] = valueItem;
         return &this;
        }
      const JsonValueItem* _getProperty(string key) const
        {
         for(int i = 0; i < ArraySize(this._jsonValueItemsArray); i++)
           {
            if(this._jsonValueItemsArray[i].key == key)
              {
               return this._jsonValueItemsArray[i];
              }
           }
         return NULL;
        }
      JSONValueItemTypes _getPropertyType(string key) const
        {
         for(int i = 0; i < ArraySize(this._jsonValueItemsArray); i++)
           {
            if(this._jsonValueItemsArray[i].key == key)
              {
               return this._jsonValueItemsArray[i].valueType;
              }
           }
         return JSONUndefinedType;
        }
      void           _clearResources()
        {
         for(int i = 0; i < ArraySize(this._jsonValueItemsArray); i++)
            del_valid_ptr(this._jsonValueItemsArray[i])
            ArrayResize(this._jsonValueItemsArray, 0);
        }
     };

   class Array
     {
   public:
                     Array()
        {
         ArrayResize(this._jsonValueItemsArray, 0, 10);
        };
                     Array(string &json)
        {
         ArrayResize(this._jsonValueItemsArray, 0, 10);
         int parceJsonCharCounter = 0;
         bool isSuccess = true;
         JSON::_parseJSONArray(json, parceJsonCharCounter, isSuccess, &this);
         if(!isSuccess)
            this._clearResources();
        };

      Array*         add(string value)             { return this._add(new JsonValueItem("", value)); }
      Array*         add(int value)                { return this._add(new JsonValueItem("", value)); }
      Array*         add(long value)               { return this._add(new JsonValueItem("", value)); }
      Array*         add(double value)             { return this._add(new JsonValueItem("", value)); }
      Array*         add(bool value)               { return this._add(new JsonValueItem("", value)); }
      Array*         add(JSON::Object* value)      { return this._add(new JsonValueItem("", value)); }
      Array*         add(JSON::Array* value)       { return this._add(new JsonValueItem("", value)); }

      bool           isBoolean(int index) const      { return this._getPropertyType(index) == JSONBoolType; }
      bool           isNumber(int index) const       { return this._getPropertyType(index) == JSONNumberType; }
      bool           isString(int index) const       { return this._getPropertyType(index) == JSONStringType; }
      bool           isObject(int index) const       { return this._getPropertyType(index) == JSONObjetType; }
      bool           isArray(int index) const        { return this._getPropertyType(index) == JSONArrayType; }

      string         getString(int index) const
        {
         const JsonValueItem* item = this._jsonValueItemsArray[index];
         if(item == NULL || item.valueType != JSONStringType)
            return "";
         return item.stringValue;
        }
      double         getNumber(int index) const
        {
         const JsonValueItem* item = this._jsonValueItemsArray[index];
         if(item == NULL || item.valueType != JSONNumberType)
            return 0.0;
         return item.doubleValue;
        }
      bool           getBoolean(int index) const
        {
         const JsonValueItem* item = this._jsonValueItemsArray[index];
         if(item == NULL || item.valueType != JSONBoolType)
            return false;
         return item.booleanValue;
        }
      JSON::Object*  getObject(int index) const
        {
         const JsonValueItem* item = this._jsonValueItemsArray[index];
         if(item == NULL || item.valueType != JSONObjetType)
            return NULL;
         return item.objectValue;
        }
      JSON::Array*   getArray(int index) const
        {
         const JsonValueItem* item = this._jsonValueItemsArray[index];
         if(item == NULL || item.valueType != JSONArrayType)
            return NULL;
         return item.arrayValue;
        }
      int            getLength() const
        {
         return ArraySize(_jsonValueItemsArray);
        }

      string         toString() const
        {
         int arraySize = ArraySize(this._jsonValueItemsArray);
         string result = "";

         for(int i = 0; i < arraySize; i++)
           {
            const JsonValueItem* item = this._jsonValueItemsArray[i];
            result += item.toString() + (i < arraySize - 1 ? "," : "");
           }

         return "[" + result + "]";
        }

                    ~Array() { this._clearResources(); }
   private:
      JsonValueItem* _jsonValueItemsArray[];

      Array*         _add(JsonValueItem* elem)
        {
         int arraySize = ArraySize(this._jsonValueItemsArray);
         ArrayResize(this._jsonValueItemsArray, arraySize + 1, 10);
         _jsonValueItemsArray[arraySize] = elem;
         return &this;
        }
      JSONValueItemTypes _getPropertyType(int index) const
        {
         if(index >= ArraySize(this._jsonValueItemsArray))
            return JSONUndefinedType;
         return this._jsonValueItemsArray[index].valueType;
        }
      void           _clearResources()
        {
         for(int i = 0; i < ArraySize(this._jsonValueItemsArray); i++)
            del_valid_ptr(this._jsonValueItemsArray[i])
            ArrayResize(this._jsonValueItemsArray, 0);
        }
     };

private:
                     JSON() {}

   static void       _parseJSONObject(const string &json, int &i, bool &isSuccess, JSON::Object* object)
     {
      JSON::_skipWhitespace(json, i);
      while(i < StringLen(json) && json[i++] != '{');  // skip '{'
      JSON::_skipWhitespace(json, i);

      while(i < StringLen(json))
        {
         JSON::_skipWhitespace(json, i);

         string key = JSON::_parseKey(json, i, isSuccess);
         if(!isSuccess)
            return;

         JSON::_skipWhitespace(json, i);
         if(json[i++] != ':')
            isSuccess = false; // wait ':'
         if(!isSuccess)
            return;
         JSON::_skipWhitespace(json, i);

         if(JSON::_isDigit(json[i]) || json[i] == '-')
           {
            object.setProperty(key, JSON::_parseNumber(json, i, isSuccess));
           }
         else
            if(json[i] == 'n' || json[i] == 'N')
              {
               object.setProperty(key, JSON::_parseNull(json, i, isSuccess));
              }
            else
               if(json[i] == 't' || json[i] == 'f')
                 {
                  object.setProperty(key, JSON::_parseBoolean(json, i, isSuccess));
                 }
               else
                  if(json[i] == '"')
                    {
                     object.setProperty(key, JSON::_parseString(json, i, isSuccess));
                    }
                  else
                     if(json[i] == '{')
                       {
                        object.setProperty(key, JSON::_parseObject(json, i, isSuccess));
                       }
                     else
                        if(json[i] == '[')
                          {
                           object.setProperty(key, JSON::_parseArray(json, i, isSuccess));
                          }
         if(!isSuccess)
            break;

         JSON::_skipWhitespace(json, i);
         if(json[i] == ',')
           {
            i++;
            continue;
           }
         else
            if(json[i] == '}')
              {
               i++;
               break; // end
              }
            else
              {
               isSuccess = false;
              }
        }
     }
   static void       _parseJSONArray(const string &json, int &i, bool &isSuccess, JSON::Array* arrayObject)
     {
      JSON::_skipWhitespace(json, i);
      while(i < StringLen(json) && json[i++] != '[');  // skip '['
      JSON::_skipWhitespace(json, i);

      while(i < StringLen(json))
        {
         JSON::_skipWhitespace(json, i);

         // check value type
         if(JSON::_isDigit(json[i]) || json[i] == '-')
           {
            arrayObject.add(JSON::_parseNumber(json, i, isSuccess));
           }
         else
            if(json[i] == '"')
              {
               arrayObject.add(JSON::_parseString(json, i, isSuccess));
              }
            else
               if(json[i] == 'n' || json[i] == 'N')
                 {
                  arrayObject.add(JSON::_parseNull(json, i, isSuccess));
                 }
               else
                  if(json[i] == 't' || json[i] == 'f')
                    {
                     arrayObject.add(JSON::_parseBoolean(json, i, isSuccess));
                    }
                  else
                     if(json[i] == '{')
                       {
                        arrayObject.add(JSON::_parseObject(json, i, isSuccess));
                       }
                     else
                        if(json[i] == '[')
                          {
                           arrayObject.add(JSON::_parseArray(json, i, isSuccess));
                          }
         if(!isSuccess)
            break;

         JSON::_skipWhitespace(json, i);
         if(json[i] == ',')
           {
            i++; // skip ','
           }
         else
            if(json[i] == ']')
              {
               i++;
               break; // end
              }
            else
              {
               isSuccess = false;
               break;
              }
        }
     }
   static bool       _isDigit(ushort ch)
     {
      return (ch >= '0' && ch <= '9');
     }
   static void       _skipWhitespace(const string &json, int &i)
     {
      while(i < StringLen(json) && (json[i] == ' ' || json[i] == '\n' || json[i] == '\r' || json[i] == '\t'))
         i++;
     }
   static string     _parseKey(const string &json, int &i, bool &isSuccess)
     {
      if(i < StringLen(json) && json[i] == '"')
        {
         i++;  // skip '"'
         string key = "";

         while(i < StringLen(json) && json[i] != '"')
            key += ShortToString(json[i++]);
         if(i < StringLen(json) && json[i] == '"')    // check end '"'
           {
            i++;  // skip '"'
            return key;
           }
        }

      isSuccess = false;
      return "";
     }
   static double     _parseNumber(const string &json, int &i, bool &isSuccess)
     {
      string numberStr = "";
      bool isNegative = false;

      if(json[i] == '-')
        {
         isNegative = true;
         i++;
        }

      while(i < StringLen(json) && JSON::_isDigit(json[i]))
        {
         numberStr += ShortToString(json[i++]);
        }

      if(i < StringLen(json) && json[i] == '.')
        {
         numberStr += ShortToString(json[i++]);
         while(i < StringLen(json) && JSON::_isDigit(json[i]))
           {
            numberStr += ShortToString(json[i++]);
           }
        }

      if(StringLen(numberStr) > 0)
        {
         double result = StringToDouble(numberStr);
         return isNegative ? -result : result;
        }

      isSuccess = false;
      return 0.0;
     }
   static string     _parseString(const string &json, int &i, bool &isSuccess)
     {
      string result = "";
      i++; // skip '"'

      while(i < StringLen(json))
        {
         if(json[i] == '"')    // if end of string
           {
            i++; // skip '"'
            return result;
           }
         else
            if(json[i] == '\\')    // check escape
              {
               i++; // // skip '\'
               if(i < StringLen(json))
                 {
                  switch(json[i])
                    {
                     case 'n':
                        result += "\n";
                        break;
                     case 't':
                        result += "\t";
                        break;
                     case 'r':
                        result += "\r";
                        break;
                     case '"':
                        result += "\"";
                        break;
                     case '\\':
                        result += "\\";
                        break;
                     default:
                        isSuccess = false;
                        return "";
                    }
                 }
              }
            else
              {
               result += ShortToString(json[i]);
              }

         i++; // next char
        }

      // not find end '"'
      isSuccess = false;
      return "";
     }
   static bool       _parseBoolean(const string &json, int &i, bool &isSuccess)
     {
      if(StringLen(json) >= i + 4)
        {
         string substringTrue = StringSubstr(json, i, 4);
         StringToLower(substringTrue);
         if(substringTrue == "true")
           {
            i += 4;
            return true;
           }
        }
      if(StringLen(json) >= i + 5)
        {
         string substringFalse = StringSubstr(json, i, 5);
         StringToLower(substringFalse);
         if(substringFalse == "false")
           {
            i += 5;
            return false;
           }
        }
      isSuccess = false;
      return false;
     }
   static string     _parseNull(const string &json, int &i, bool &isSuccess)
     {
      if(StringLen(json) >= i + 4)
        {
         string substring = StringSubstr(json, i, 4);
         StringToLower(substring);

         if(substring == "null")
           {
            i += 4;
            return "null";
           }
        }
      isSuccess = false;
      return "";
     }
   static JSON::Object* _parseObject(const string &json, int &i, bool &isSuccess)
     {
      JSON::Object* childObject = new JSON::Object();
      JSON::_parseJSONObject(json, i, isSuccess, childObject);
      return childObject;
     }
   static JSON::Array* _parseArray(const string &json, int &i, bool &isSuccess)
     {
      JSON::Array* childObject = new JSON::Array();
      JSON::_parseJSONArray(json, i, isSuccess, childObject);
      return childObject;
     }

   class JsonValueItem
     {
   public:
      string         key;
      JSONValueItemTypes valueType;

      string         stringValue;
      double         doubleValue;
      bool           booleanValue;
      JSON::Object*  objectValue;
      JSON::Array*   arrayValue;

                     JsonValueItem(string k, string value): key(k), valueType(JSONStringType), stringValue(value) {};
                     JsonValueItem(string k, int value): key(k), valueType(JSONNumberType), doubleValue(double(value)) {};
                     JsonValueItem(string k, long value): key(k), valueType(JSONNumberType), doubleValue(double(value)) {};
                     //JsonValueItem(string k, double value): key(k), valueType(JSONNumberType), doubleValue(value) {};
                     JsonValueItem(string k, bool value): key(k), valueType(JSONBoolType), booleanValue(value) {};
                     JsonValueItem(string k, JSON::Object* value): key(k), valueType(JSONObjetType), objectValue(value) {};
                     JsonValueItem(string k, JSON::Array* value): key(k), valueType(JSONArrayType), arrayValue(value) {};
                     JsonValueItem(string k, double value) : key(k), valueType(JSONNumberType), doubleValue(value)
        {
         if(!MathIsValidNumber(value))
            valueType = JSONNullType;
        };

      string         toString() const
        {
         if(this.valueType == JSONBoolType)
            return string(this.booleanValue);
         if(this.valueType == JSONNumberType)
            return string(this.doubleValue);
         if(this.valueType == JSONObjetType)
            return this.objectValue.toString();
         if(this.valueType == JSONArrayType)
            return this.arrayValue.toString();
         if(this.valueType == JSONStringType)
           {
            string copy = this.stringValue;
            StringReplace(copy, "\"", "\\\"");
            return "\"" + copy + "\"";
           }

         if(this.valueType == JSONNullType)
            return "null";
         return ""; // JSONUndefinedType , never returns
        }

                    ~JsonValueItem()
        {
         if(this.valueType == JSONObjetType)
            del_valid_ptr(this.objectValue)
            if(this.valueType == JSONArrayType)
               del_valid_ptr(this.arrayValue)
              }
     };
  };
//+------------------------------------------------------------------+
