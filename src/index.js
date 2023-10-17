const handler = async (event, context) => {
    try {
      console.log('Received event:', JSON.stringify(event, null, 2));
  
    //   for (const record of event.Records) {
    //     const { body, messageAttributes } = record;
    //     console.log('Processing message:', body);
  
    //     // Your processing logic here
    //     // Example: You might want to parse the message body as JSON
    //     // const messageData = JSON.parse(body);
  
    //     // Perform your custom logic on the messageData
    //   }
  
      return { statusCode: 200, body: 'Messages processed successfully' };
    } catch (error) {
      console.error('Error:', error);
      throw error;
    }
  };
  var _default=exports.default=handler