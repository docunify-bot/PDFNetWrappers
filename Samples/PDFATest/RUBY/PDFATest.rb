#---------------------------------------------------------------------------------------
# Copyright (c) 2001-2018 by PDFTron Systems Inc. All Rights Reserved.
# Consult LICENSE.txt regarding license information.
#---------------------------------------------------------------------------------------

require '../../../PDFNetC/Lib/PDFNetRuby'
include PDFNetRuby

$stdout.sync = true

#---------------------------------------------------------------------------------------
# The following sample illustrates how to parse and check if a PDF document meets the
# PDFA standard, using the PDFACompliance class object. 
#---------------------------------------------------------------------------------------

# Relative path to the folder containing the test files.
input_path = "../../TestFiles/"
output_path = "../../TestFiles/Output/"

def PrintResults(pdf_a, filename)
	err_cnt = pdf_a.GetErrorCount
	if err_cnt == 0
		puts filename + "OK."
	else
		puts filename + " is NOT a valid PDFA."
	end

	i = 0

	while i < err_cnt do
		c = pdf_a.GetError(i)
		str1 = " - e_PDFA " + c.to_s + ": " + PDFACompliance.GetPDFAErrorMessage(c) + "."
		if true
			num_refs = pdf_a.GetRefObjCount(c)
			if num_refs > 0
				str1 = str1 + "   Objects:\n"
				j = 0
				while j < num_refs do
					str1 = str1 + pdf_a.GetRefObj(c, j).to_s
					if j < num_refs-1
						str1 = str1 + ", "
					end
					j = j + 1
				end
			end
		end
		puts str1
		i = i + 1
	end
end
	
	PDFNet.Initialize
	PDFNet.SetColorManagement	 # Enable color management (required for PDFA validation).
	
	#-----------------------------------------------------------
	# Example 1: PDF/A Validation
	#-----------------------------------------------------------
	filename = "newsletter.pdf"
	pdf_a = PDFACompliance.new(false, input_path+filename, nil, PDFACompliance::E_Level1B, 0, 10)
	PrintResults(pdf_a, filename)
	pdf_a.Destroy
	
	#-----------------------------------------------------------
	# Example 2: PDF/A Conversion
	#-----------------------------------------------------------
	filename = "fish.pdf"
	pdf_a = PDFACompliance.new(true, input_path + filename, nil, PDFACompliance::E_Level1B, 0, 10)
	filename = output_path + "pdfa.pdf"
	pdf_a.SaveAs(filename, true)
	pdf_a.Destroy
	
	# Re-validate the document after the conversion...
	pdf_a = PDFACompliance.new(false, filename, nil, PDFACompliance::E_Level1B, 0, 10)
	PrintResults(pdf_a, filename)
	pdf_a.Destroy
	
