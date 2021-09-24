using System;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace DataBase.WA_API
{
    public class SecretariaNaty
    {
        private string APIUrl = "";

        private string token = "";
        private string whatsappId = "";

        public SecretariaNaty(string aPIUrl, string token)
        {
            APIUrl = aPIUrl;
            this.token = token;
            Requests req = new Requests();
            req.apiToken = this.token;
            req.urlAPI = APIUrl+ "/whatsapps";
            var GET = req.GetRequest();
            GET = "{\"whatsappIDs\":" + GET + " } ";
            var retornoGET = JsonConvert.DeserializeObject<RootWhatsappID>(GET);
            for (int i = 0; i < retornoGET.whatsappIDs.Length; i++)
            {
                if (retornoGET.whatsappIDs[i].status == "CONNECTED")
                {
                    this.whatsappId = retornoGET.whatsappIDs[i].id;
                }
            }
        }
        public void SendMessage(string to,string numto,string body)
        {
            Requests req = new Requests();
            req.apiToken = this.token;
            req.urlAPI = this.APIUrl + "/messages";
            RootMessage message = new RootMessage();
            message.whatsappId = this.whatsappId;
            Message[] send = { new Message { name = to, number = numto, body = body } };
            message.messages = send;
            var POST = req.PostRequest(JsonConvert.SerializeObject(message));
        }
    }
}

public class RootWhatsappID
{
    public WhatsappID[] whatsappIDs { get; set; }
}

public class WhatsappID
{
    public string id { get; set; }
    public string name { get; set; }
    public string status { get; set; }
}

public class RootMessage
{
    public string whatsappId { get; set; }
    public Message[] messages { get; set; }
}

public class Message
{
    public string number { get; set; }
    public string name { get; set; }
    public string body { get; set; }
}

public class Requests
{
    public string urlAPI { get; set; }
    public string apiToken { get; set; }
    public string PostRequest(String contentJSON)
    {
        string retorno = string.Empty;
        HttpWebRequest myRequest = (HttpWebRequest)HttpWebRequest.Create(urlAPI);
        myRequest.Method = "POST";
        byte[] dataJSON = Encoding.ASCII.GetBytes(contentJSON);
        myRequest.ContentType = "application/json";
        myRequest.ContentLength = dataJSON.Length;
        myRequest.Headers.Add("Authorization", "Bearer " + apiToken);
        Stream reqStream = myRequest.GetRequestStream();
        reqStream.Write(dataJSON, 0, dataJSON.Length);
        reqStream.Close();
        HttpWebResponse myResponse = (HttpWebResponse)myRequest.GetResponse();
        Stream respStream = myResponse.GetResponseStream();
        StreamReader myReader = new StreamReader(respStream, Encoding.Default);
        switch (myResponse.StatusCode)
        {
            case HttpStatusCode.NoContent:
                retorno = "OK";
                break;
            case HttpStatusCode.Created:
                retorno = myReader.ReadToEnd();
                break;
            default:
                retorno = myResponse.StatusCode.ToString();
                break;
        }
        myReader.Close();
        respStream.Close();
        myResponse.Close();
        return retorno;
    }
    public string GetRequest()
    {
        HttpWebRequest myRequest = (HttpWebRequest)HttpWebRequest.Create(urlAPI);
        myRequest.Method = "GET";
        myRequest.ContentType = "application/json";
        myRequest.Headers.Add("Authorization", "Bearer " + apiToken);
        using (var resposta = (HttpWebResponse)myRequest.GetResponse())
        {
            var streamDados = resposta.GetResponseStream();
            StreamReader reader = new StreamReader(streamDados);
            object objResponse = reader.ReadToEnd();
            var response = objResponse.ToString();
            if (resposta.StatusCode == HttpStatusCode.OK)
            {
                streamDados.Close();
                resposta.Close();
                return response;
            }
            else
            {
                streamDados.Close();
                resposta.Close();
                return null;
            }
        }
    }
    public string PatchRequest(String contentJSON)
    {
        string retorno = string.Empty;
        HttpWebRequest myRequest = (HttpWebRequest)HttpWebRequest.Create(urlAPI);
        myRequest.Method = "PATCH";
        byte[] dataJSON = Encoding.ASCII.GetBytes(contentJSON);
        myRequest.ContentType = "application/json";
        myRequest.ContentLength = dataJSON.Length;
        myRequest.Headers.Add("Authorization", apiToken);
        Stream reqStream = myRequest.GetRequestStream();
        reqStream.Write(dataJSON, 0, dataJSON.Length);
        reqStream.Close();
        HttpWebResponse myResponse = (HttpWebResponse)myRequest.GetResponse();
        Stream respStream = myResponse.GetResponseStream();
        StreamReader myReader = new StreamReader(respStream, Encoding.Default);
        switch (myResponse.StatusCode)
        {
            case HttpStatusCode.NoContent:
                retorno = "OK";
                break;
            case HttpStatusCode.Created:
                retorno = myReader.ReadToEnd();
                break;
            default:
                retorno = myResponse.StatusCode.ToString();
                break;
        }
        myResponse.Close();
        myReader.Close();
        respStream.Close();
        return retorno;
    }
}
