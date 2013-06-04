package controler.serialization
{
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author kamal
	 * 
	 */
	public class XmiController extends EventDispatcher
	{
		
		/**
		 * 
		 */
		public static const UML:Namespace = new Namespace("UML", "http://www.omg.org/UML/1.4");
		public static const XMI:Namespace = new Namespace("xmi", "http://www.omg.org/XMI");
		public static const XSI:Namespace = new Namespace("XSI", "http://www.omg.org/XSI");
		
		public static const XMI_DOCUMENT_VERSON		:String = "2.0";
		public static const XMI_HEADER_VERSON		:String = "1.4";
		public static const XML_VERSION				:String = "1.0";
		public static const XML_ENCODING			:String = "UTF-8";
		
		
		private static const XML_ROOT_NAME:String = XMI.prefix;
		private static const XML_ROOT_HEADER:XML = new XML(	"<?xml version='1.0'" +
															" encoding='utf-8'?>");
		
		private static var _isCreationAllowed	:Boolean		= false;
		private static var _instance			:XmiController	= null;
		
		private static var _xmiGlobalDocument	:XML = null;
		private static var _xmiModel			:XML = null;
		
		/**
		 * 
		 * 
		 */
		public function XmiController()
		{
			if (_isCreationAllowed)
			{
				XML.ignoreComments = false;
				XML.ignoreProcessingInstructions = false;
				
				_xmiGlobalDocument = <{XMI.prefix} xmi.version={XMI_DOCUMENT_VERSON} />;
				_xmiGlobalDocument.addNamespace(XMI);
				_xmiGlobalDocument.addNamespace(UML);
				_xmiModel = <{XML_ROOT_NAME + ".model"} />;
			}
			else
			{
				throw new IllegalOperationError("this is a singleton class");
			}
		}
		
		public static function getInstance():XmiController
		{
			if (_instance != null)
			{
				return _instance;
			}
			else
			{
				_isCreationAllowed	= true;
				_instance			= new XmiController();
				_isCreationAllowed	= false;
				
				return _instance;
			}
		}
		
		public function write():void
		{
			var header:XML = buildXMIHeader();
			_xmiGlobalDocument.appendChild(header);
			
			var body:XML = 
				<Class id='id345' visibility='public' isAbstract='false' name='MyClass'>
					<ownedAttribute id='id1138' name="myAttr" visibility='private' type='id42'/>
					<ownedOperation id='id1139' name='myOperation' visibility='public'>
						<ownedParameter id='1140' name='par1' type='id123' />
					</ownedOperation>
				</Class>;
			
			_xmiModel.appendChild(body);
			
			_xmiGlobalDocument.appendChild(_xmiModel);
			trace (_xmiGlobalDocument.toXMLString());
		}
		
		public function read():void
		{
			
		}
		
		public function setAttributeXmiNamespace(elementXml:XML, index:uint):void
		{
			var attributes:XMLList = elementXml.attributes() as XMLList;
			
			if (index < attributes.length())
			{
				(attributes[index] as XML).setNamespace(XMI);
			}
		}
		
		private function buildXMIHeader():XML
		{
			var header:XML = 
				<XMI.header>
					<XMI.metamodel xmi.name={UML.prefix} xmi.version={XMI_HEADER_VERSON} />
					<XMI.documentation >
						<XMI.exporter> Kamal EL FARSAOUI </XMI.exporter>
						<XMI.exporterVersion> 1.0 </XMI.exporterVersion>
					</XMI.documentation>
				</XMI.header>;
			
			return header;
		}
		
		public function addUmlNamspace(tree:XML):void
		{
			tree.setNamespace(UML);
			if (tree.children().length())
			{
				for each (var child:XML in tree.children())
				{
					addUmlNamspace(child);
				}
			}
		}
		
		private function addHeaderEntry(entryLocalName:String, attributes:Dictionary=null):XML
		{
			var strAttributes:String = "";
			
			if (attributes != null)
			{
				for (var key:* in attributes)
				{
					strAttributes += (XMI.prefix as String).toLowerCase() + '.' + (key as String);
					
					strAttributes += '="' + attributes[key] + '" ';
				}
			}
			
			var strEntry:String = "<" + XMI.prefix + "." + entryLocalName + " " + 
				strAttributes + ">";
			
			return new XML(strEntry);
		}
		
	}
	
}

/*

Final Product:

An AIR application with a load xml and save xml button. The load button prompts 
the user to find an xml file titled "person.xml." Once the user has selected 
the file, the first name and last name of the person will be displayed in two 
text inputs. The user can then edit these entries and save them back to the file 
using the save button.

The Data:

<?xml version="1.0" encoding="UTF-8"?>
<person>
	<firstName>John</firstName>
	<lastName>Doe</lastName> 
</person>



private function loadXML():void
{
	file = new File();
	file.addEventListener(Event.SELECT, dirSelected);
	file.browseForOpen("Select person.xml file"); 
}

4. Setup the event listener function that will read the xml file and create an 
XML object. If the user has not picked a file with the name "person.xml," 
the application will fire a prompt informing them of their mistake:


private function dirSelected(e:Event):void
{
	if (file.nativePath.indexOf("person.xml") != -1)
	{
		var fs:FileStream = new FileStream();
		fs.open(file, FileMode.READ);
		personXML = XML(fs.readUTFBytes(fs.bytesAvailable));
		fs.close();
		setTextInputs(); 
	}
	else
	{
		Alert.show("You have not selected an xml file called 'person.xml'"); 
	}
}


6. Last is the function to save the xml back to the originally opened file:


private function saveXML():void
{
	personXML.firstName = fName_txti.text;
	personXML.lastName = lName_txti.text;
	var newXMLStr:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + personXML.toXMLString();
	var fs:FileStream = new FileStream();
	fs.open(file, FileMode.WRITE);
	fs.writeUTFBytes(newXMLStr);
	fs.close();
}

NOTE: If the application used "writeUTF" instead of "writeUTFBytes" the xml 
file ends up with some garbage characters that causes parse errors when the 
app tries to reopen and parse the xml.

7. Check out the project "Enumerate Class Instance" to see how to save a class 
object to XML. Enjoy!


*/