Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue

$url = 'https://minerva/sites/ejt'

#Get the Web
$web = Get-SPWeb -Identity $url

#Get the List/Library
$list = $web.Lists.TryGetList("Service Management Tool 2.0")

function AddChoiceValues($list, $fieldName, $fieldValues)
{
	$ChoiceField = $list.Fields.GetField($fieldName) #Get the field
	if($ChoiceField)
	{
		$ChoiceField.Choices.Clear()
		foreach ($choiceValue in $fieldValues)
		{
			#Add Choices to the field		
			$ChoiceField.Choices.Add($choiceValue)
		}
		
		#Commit changes
		$ChoiceField.update()	
	}
}

$priorityValues = @("Critical","High","Medium","Medium")
 
if($list)  #Check If List exists!
{
	AddChoiceValues $list "Priority" $priorityValues
}
