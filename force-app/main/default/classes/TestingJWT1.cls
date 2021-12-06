public class TestingJWT1 {

    public String keyData { get;set;}
    public String url { get;set;}
    public TestingJWT1(){
        url = '';
        if(url != null && url != ''){
            url = url +'api/create-chat';
        }
        keyData = apexpages.currentpage().getparameters().get('data');
        if(keyData == null || keyData == ''){
           keyData = '';
        }
        system.debug('ChatBotServices:constructor:keyData>>:'+keyData);
        system.debug('ChatBotServices:constructor:url>>:'+url);
    }    
 
    @AuraEnabled 
    public static String getWindowLoginData(String lang){
       
        userWrap uData = new userWrap();
         String strUserData;
       
       
            List<User> loginUsers = [select id,FirstName,LastName,Email,Name,Phone,LanguageLocaleKey,ContactId from User where id =: userInfo.getUserId()];
            
                uData.firstname = loginUsers[0].FirstName;
                uData.lastname = loginUsers[0].LastName;
                uData.contactId = loginUsers[0].ContactId;
                uData.name = loginUsers[0].Name;
                 uData.email = loginUsers[0].Email;
                 uData.phone = loginUsers[0].Phone;
                uData.language = loginUsers[0].LanguageLocaleKey;
                uData.supportEntitled = true;                
            
     
    
            String header = '{"alg": "RS256","typ":"jwt","kid":"2eg3262f-3b32-4d5a-cgd5-2acc1424bc2"}';
            //String payload = '{"firstname":" '+ uData.firstname +' ","lastname":" '+ uData.lastname + ' ","email":"'+uData.email+'"}';
            String payload = '{"firstname":" '+uData.firstname+' ","lastname":" '+uData.lastname+ ' ","email":"'+uData.email+'","phone":"'+uData.phone+'","name":"'+uData.name+'","language":"'+uData.language+'","contactId":"'+uData.contactId+'","aud":"AVA_IT"}';
            //String payload=JSON.serialize(uData);
            //System.debug('value of payload-->'+payload);
            string jwt = base64URLencode(blob.valueof(header)) + '.' +base64URLencode(blob.valueof(payload));
            
        // Blob key = blob.valueof('-----BEGIN RSA PRIVATE KEY-----MIIEogIBAAKCAQEAmGHTYFVmVrqXyvDpglyI14kFaI4aH/Lq2i6Mr3bRHXhnnT0+eEzQcfmJZ5E1DkYSOAhvVwpaYUlqPfE6AbCIb3OKmjDIYAXFf5POtLKYAgCafh5znuz5NAf2Z+eXifDHdEL5PjOBomCGn+O48CQE/wl7KNigrO8YE0FFl63/HRKhxFRgyFfok7npqnb5n5hS0wPb2QD8JF4mj9UIBS4pSBXi22+bQyMSzQlGqoZ4ZHAGd7IqqCPa8CUulnAVQVN7QBW0zZ7V0k/XKxQgfBR6BxJBP+q3yMe7OgAaBaEjCN7LbQjDS6LtHzYmclWzWgsCKMFOT88IiZihkX7vX8IjyQIDAQABAoIBAATPidHPwGRajbI9etG/xB4x2DbdzZtWmu16bLyZXq60f2jqZw97NVVz0E+xuOATfD3Cnmk8DXBm1fDQrckh3pzOJAEMKzdE12BYtTzlKoFdrYLvySyqRI/M9I2BNTqInHNiLeY10BDlRTrFALCsInA+x2GZvTDYd4UcGWtZdeVgBbxGu1xHFR019kzvyJp2wgpERrRF2C/Eh8lB8cHuZUDWGiqBJF3iiEchTXu1pHC4YW74u/JMxfFAdTsj9jSbsjLjBaZrq4NHK/SftoUWkQDS9bUQ6bAVHRK0VGzdgPjcsu6nazvcczguENLKrMNOAiplImYW05fUrM2wMzPjOhECgYEAyTxvifJZzbIbFs3rbBY+iStakmCxu0gfu2Z0rEgx9VjcIZHrvmoR1QvE94a5+LE9bo9sJiUGDGRglXqEMClIpxnvnrb8SBowApG9A6qF/6jzIVJdMx+fGi7qUcDqIwojGMwoVzp8UOsYV66SsXJwrE1Zuro/uMDSyF1Ce6j6EuUCgYEAwdnespTa6ratHP0zJFWWGzDXEjfHF5UCdtGPf4MPW79MMNFVernGnHN95Fu1trct32Fiu8EEScd7Cr57AlkDbcBKZZfFVI/TtPL2de4BCra3vkz/IkuEyiUE0Khzdnv9bK000hxTZBNK2G7xtZCl6G2917uEdm5Kx/XgCcoHyxUCgYAN1HF18YnqcQsbjhtX2k+B7dDTroGIdXR41JnAHVYRnoHCbNzewTtogN6QhFnTlZq7NnAgTvsTbvKUU08yYCP2F/o31iuQaPxTsOBkmBuNbncHGzn8gXfVvNOtuqxcrB2tXpqHJCXXCdEqdXzvZQYJUWeRRauLbvUNgBtJlFtbYQKBgEz/K8yFAZs+6e3cyGaDNDcipBqRWxwLzMnDHRtJxFzt0+aED07K4Y+c9AEzSC8F/Ut/1Aa9eOWRPVccJ6HcF1eNjD9kFDYtVqrF4o0e9vz5bGxDCwflNR5Rq+LxNcN3Jkb3WUanh5v1acIj9w/mH2/9vu0kh02/KybXi6B3xbatAoGAd6AT2KwPzwm6d5lDrt/vS7dzOLrdLo2QuXc2/CheRsZx1v9U49W8qONWcqVsK+GMVleHXI7uZy/jjTxvOPVdqdXE30wcHuNi5eyYMnNwbVLplvEk7AK1tQzUO6oYnZvjgg+niyKHJNFXnFqyE91B1Xfcet5ok89BkzAYRP90bM8=-----END RSA PRIVATE KEY-----');
        //string privateKey = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDRBAeZ/UMOPO0t6BDdzaUtahj1ODzpdA13IiOqtsJ8CZ6Zrs6gzGWELm9Pa3Ou0BxEa9ahrPMk7mgsf/A1xuznrRPyllDmtIqzm6ZNb3haOTJqfmFHwgMnVTV6vHOfsBcqhJynplHIxyOVl4TU1I8c5+4ttlVByha1hDfP7VBB1xWwpCPN7Prw8Z3mabthZtujKwLanKBlY4dPQNQ0EOECNY4bWPoWQrg+gr0/FSYaVB1cD1obhBAv1RaLDiWPrzcyP4CUkFuXRGKYdbCSbsnO0PUydbK44z+1eJDocwgtqNP3KlUTn+LCZiibSHmtWiPwwNqulAgNtQArj4KvPV0bAgMBAAECggEABKfxbJs8YRCELtq1p+AHkKIfHM6CmnRRqaufhGAedF/mFUG6uNDeZ0B99BSn/ScF2JPxMiT/Pf13lM79MJCvwOtu/2wcyj7cVh4ez477oEFLUuouZZUehKpJW8rff0x1zHMrmcp1/CIZGoet14XfcdyyxniCbRanRQze2pyZOWMBLKc/hT9uh5VXZNlcEdvK7EbHVjl7x0Ht1iJyuZYyEw0XLR5N/MvoYxJX7GlJoEVoPd+8Mo2BSjuFt8q+2EaZTBqIgAjrhPUvPCdOcYmn63c0V49Ogm3EvlLl+HBFd7NC1/+WY6mS0xQABKHR4Z45UqOj6zeozSLFRVL2gMel/QKBgQDt6tnX6JNI5TCaNaLu3q0vka+EstoR5GgB+3x94YrRxBvR4sopaREGB7dxi2UpkvnNleXyFki/ZuN3IEBXLmQKybw7hP1/aQbBhut3zzyyP9Crtm2nJ6hYJEALc3kY3gzkkmmtgvQhuBFkES0JdOaW0+gLUlxczIArbRbomoTTnQKBgQDg5tcwipPmTIR370fxszwjnOOQN1zrspJKqPTz2s45h6Z8yyzTdue8CZmVZM+hodfPgW1GBXWPkqJoAK+RkDp3h5kH1SjZSorSTSc3lHI+gERgN3oQ6M5UdrengRp/PzVc0mVv85PNjTYdzoqX3IwTfkfDnm9ksWKz3bIhhGmiFwKBgQDXBl2yTEnpJPLDPNywJOLDTlkihn6ekx8JQ6BlKNXM9f/qtpzdxk6Tc5/w5/obE/HfQ63aGRfQnQ3R2X0tDglu0prj9DMj1uk7OVRRKSSDOTfAKZV68FWuq7ySXN/CgNWIM2d9YRCB9RkKppdcp6HMCWL78Ij3egAQv3xn51dK5QKBgBGYHYePn8hpfgd/8ann8rF6iZbzrdJGkwlCNH+LQ4zentiucGBOsgxU1+4HB/NGHQL/xhOvQ6Yqu4fVXebOWLSXKBKjy2FMYpXXMVU4yMM496BrVqJSBCo5a16wS+legYc0cnkSniJ7hJtKWC9PMqonu+eC0oYXFnipxFC48iabAoGAXa2g6nNB2B+vcxNNqHzEboa1M0BrYECyXcmqGK7gHZ2uF3iu2VviWDyUKWh/7iXXoVV6bHTeOF+/NzxhmZBJFT5QHAFFABYOcSO++ooydSQIroraQHZg3RP+3pAYXnaNEGSeEWZhHnffvH47yat3EhbuwVfIA7fdijKOa/rBjAs=';
          string privateKey = 'MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDRBAeZ/UMOPO0t6BDdzaUtahj1ODzpdA13IiOqtsJ8CZ6Zrs6gzGWELm9Pa3Ou0BxEa9ahrPMk7mgsf/A1xuznrRPyllDmtIqzm6ZNb3haOTJqfmFHwgMnVTV6vHOfsBcqhJynplHIxyOVl4TU1I8c5+4ttlVByha1hDfP7VBB1xWwpCPN7Prw8Z3mabthZtujKwLanKBlY4dPQNQ0EOECNY4bWPoWQrg+gr0/FSYaVB1cD1obhBAv1RaLDiWPrzcyP4CUkFuXRGKYdbCSbsnO0PUydbK44z+1eJDocwgtqNP3KlUTn+LCZiibSHmtWiPwwNqulAgNtQArj4KvPV0bAgMBAAECggEABKfxbJs8YRCELtq1p+AHkKIfHM6CmnRRqaufhGAedF/mFUG6uNDeZ0B99BSn/ScF2JPxMiT/Pf13lM79MJCvwOtu/2wcyj7cVh4ez477oEFLUuouZZUehKpJW8rff0x1zHMrmcp1/CIZGoet14XfcdyyxniCbRanRQze2pyZOWMBLKc/hT9uh5VXZNlcEdvK7EbHVjl7x0Ht1iJyuZYyEw0XLR5N/MvoYxJX7GlJoEVoPd+8Mo2BSjuFt8q+2EaZTBqIgAjrhPUvPCdOcYmn63c0V49Ogm3EvlLl+HBFd7NC1/+WY6mS0xQABKHR4Z45UqOj6zeozSLFRVL2gMel/QKBgQDt6tnX6JNI5TCaNaLu3q0vka+EstoR5GgB+3x94YrRxBvR4sopaREGB7dxi2UpkvnNleXyFki/ZuN3IEBXLmQKybw7hP1/aQbBhut3zzyyP9Crtm2nJ6hYJEALc3kY3gzkkmmtgvQhuBFkES0JdOaW0+gLUlxczIArbRbomoTTnQKBgQDg5tcwipPmTIR370fxszwjnOOQN1zrspJKqPTz2s45h6Z8yyzTdue8CZmVZM+hodfPgW1GBXWPkqJoAK+RkDp3h5kH1SjZSorSTSc3lHI+gERgN3oQ6M5UdrengRp/PzVc0mVv85PNjTYdzoqX3IwTfkfDnm9ksWKz3bIhhGmiFwKBgQDXBl2yTEnpJPLDPNywJOLDTlkihn6ekx8JQ6BlKNXM9f/qtpzdxk6Tc5/w5/obE/HfQ63aGRfQnQ3R2X0tDglu0prj9DMj1uk7OVRRKSSDOTfAKZV68FWuq7ySXN/CgNWIM2d9YRCB9RkKppdcp6HMCWL78Ij3egAQv3xn51dK5QKBgBGYHYePn8hpfgd/8ann8rF6iZbzrdJGkwlCNH+LQ4zentiucGBOsgxU1+4HB/NGHQL/xhOvQ6Yqu4fVXebOWLSXKBKjy2FMYpXXMVU4yMM496BrVqJSBCo5a16wS+legYc0cnkSniJ7hJtKWC9PMqonu+eC0oYXFnipxFC48iabAoGAXa2g6nNB2B+vcxNNqHzEboa1M0BrYECyXcmqGK7gHZ2uF3iu2VviWDyUKWh/7iXXoVV6bHTeOF+/NzxhmZBJFT5QHAFFABYOcSO++ooydSQIroraQHZg3RP+3pAYXnaNEGSeEWZhHnffvH47yat3EhbuwVfIA7fdijKOa/rBjAs=';
            Blob privateKeyBlob = EncodingUtil.base64Decode(privateKey);
        // Blob key = blob.valueOf('QtvdArkoBdrJir0S065Fw9gUJkgk+yllIZrAQ7vcvB09tOQktjFU1M2sLmFHsSNWSV9dLzYQqGYpuFakAVes6uBlRGJ7kl7rMnVAurDPP0rainPbn27SCu2ypr1s4C2jc7A3sKaCsHDo318tRbg88HcQAxqiKvqIwW9njl6Qx6qMQ9PxIEZlnewkOEMd9PtWa/+ZdTy2UzTGxzILvIRMDNlr+gPyI2P/n7tRlJCNXsSt0vVvo/z2rcfwKmKH0HnmIjl5VujH/JNmAvmWyDd0scBYaJ3LzXZaozvqBMDu8kC92K44xMZwN1k7GcyaO4HomtSWJSI8BIA0T16aAwGuZbyx7SAKbNO2zcHuMrPorxW9GiCtfTjJgKNDJ8/CMTjhmaRJZ/hnjojgzgskqUEMsJpEahSypff1CtWmMh1V9hv9POwo8GS9WmFJVDglXuYrzyvvRREqISTewrrXRmeWV0331GTXMahoFZWNifImxDMdx3/6ud3UdxmT4oBPplZ1Y1dfaf0Hi77CnUvVDKLvAzI6b2+ztZ+uIXsWyxqLHLHU60m6BPpIeDYc8u8uz5g+LawrAtRBa2oLll04shXKqvSr35U+IzH4+YTHsaUegOQ6koaqzI/H+H05OWdIaB7UdK669ffkAqIhKRXtRgHBTz6hn3TsDjYjRAPXr6i9rKRHwSUxwQ57MWG9ay4r7YBWSRLhqQ0MiX+uX1MGBRYvDP1KDWcISM9aznPha/NX/dQCxzrgeWPEIeu3hupK8+TC+rasAkixJbwSPY3WITVuLyU7NJFUgdfwS3ZDasELGcOK54yVVV7425bzfL8fMnj2');
            blob signature = Crypto.sign('RSA-SHA256',Blob.valueof(jwt),privateKeyBlob);
            //system.debug('JWT' +jwt);
            //system.debug('final data --> '+jwt+'.'+base64URLencode(signature));
            jwt += '.'+ base64URLencode(signature);
            // return jwt;
         strUserData = JSON.serialize(jwt);
        system.debug('Final JWT Token -->' +strUserData);
        return EncodingUtil.urlEncode(strUserData, 'UTF-8');
  
    }


public static String base64URLencode(Blob input){ 
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while ( output.endsWith('=')){
            output = output.subString(0,output.length()-1);
        }
        //output = output.replaceAll('=','');
        system.debug('output is'+output);
        return output;
    }
        //wrapper class to hold information of user
    public class userWrap{
        @AuraEnabled 
        public String firstname{get;set;}
        @AuraEnabled 
        public String lastname{get;set;}
        @AuraEnabled 
        public String contactId{get;set;}
        @AuraEnabled 
        public String name{get;set;}
        @AuraEnabled 
        public String language{get;set;}
        @AuraEnabled 
        public String email{get;set;}
        @AuraEnabled 
        public String phone{get;set;}
        @AuraEnabled 
        public Boolean supportEntitled{get;set;}        
    }


}