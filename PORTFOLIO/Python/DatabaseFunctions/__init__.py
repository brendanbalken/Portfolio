import xlrd
import win32com.client
import sys
import datetime
import numpy
import _pickle as pickle



class Participant:
	def __init__(self, PpID):
		self.PpID = PpID
		self.TASK = self.TASK()
		save_object(self, 'Z:\\Database\\' + PpID + '.pkl')
	
	@property
	def DOB(self):
		return self._DOB
	@DOB.setter
	def DOB(self, DOB):
		self._DOB = DOB
		self.AGE = calculate_age(DOB)
		self.AGEGROUP = 'O' if int(self.AGE)>40 else 'Y'
	
	
	class TASK:
		def __init__(self):
			self.CAPio = self.CAPio()
			self.N1P2io = self.N1P2io()
			self.AuditoryTetanization1kHz = self.AuditoryTetanization1kHz()
			self.AuditoryTetanization4kHz = self.AuditoryTetanization4kHz()
			self.VisualTetanization = self.VisualTetanization()
			self.SlowPresentation = self.SlowPresentation()
		class CAPio:
			def __init__(self):
				pass
			@property
			def DATE(self):
				return self._DATE
			@DATE.setter
			def DATE(self, taskdate):
				self._DATE = taskdate
				self.Completed = True if taskdate else False
		class N1P2io:
			def __init__(self):
				pass
		class AuditoryTetanization1kHz:
			def __init__(self):
				pass
		class AuditoryTetanization4kHz:
			def __init__(self):
				pass
		class VisualTetanization:
			def __init__(self):
				pass
		class SlowPresentation:
			def __init__(self):
				pass

def save_object(obj, filename):
    with open(filename, 'wb') as output:  # Overwrites any existing file.
        pickle.dump(obj, output, 4)
		

def searchMat(matrix, rowHeader, columnHeader):
	value = matrix[numpy.where(matrix == rowHeader)[0], numpy.where(matrix == columnHeader)[1]]
	return value[0]

def displayTable(data, orientation, quiet):
	if len(data.shape)==1:
		for each in data:
			line = ''
			if isinstance(each, datetime.datetime):
				line += '{:^15}'.format(str(each)[0:10])
			elif isinstance(each, float):
				if each.is_integer():
					line += '{:^15}'.format('{:.0f}'.format(each))
				else:
					line += '{:^15}'.format(str(each))
			else:
				line += '{:^15}'.format(str(each))
			if orientation=='column' & quiet is False:
				print(line + '\n')
	else:
		newData = []
		numColumns = len(data[0])
		for row in data:
			w = 1
			line = ''
			newRow = []
			for col in row:
				if w == 15:
					line += ' and ' + str(numColumns-15) + ' more columns...'
				w += 1
				if isinstance(col, datetime.datetime):
					item = '{:^15}'.format(str(col)[0:10])
				elif isinstance(col, float):
					if col.is_integer():
						item = '{:^15}'.format('{:.0f}'.format(col))
					else:
						item = '{:^15}'.format(str(col))
				elif col is None:
					item = '{:^15}'.format('{:}'.format(''))
				else:
					item = '{:^15}'.format(str(col))
				newRow.append(item.strip())
				line += item
			newData.append(newRow)
			if quiet is False:
				print(line + '\n')
	return newData


def importExcel(filename, password, sheet, sheetrange):
	# Inputs are filename, password, sheet, and sheetrange
	# filename and password should be a string
	# sheet should be an integer (first sheet is 1)
	# sheetrange should be a nested tuple - ex: ((1, 1), (6, 9)) will read
	# starting from cell A1 to cell I6
	import xlrd
	import win32com.client
	import sys
	import datetime
	
	
	xlApp = win32com.client.Dispatch("Excel.Application")
	book = xlApp.Workbooks.Open(filename, False, True, None, password) if 'password' in locals() else xlApp.Workbooks.Open(filename, False, True)
	sheet1 = book.Sheets(sheet)
	data = sheet1.Range(sheet1.Cells(sheetrange[0][0],sheetrange[0][1]), sheet1.Cells(sheetrange[1][0],sheetrange[1][1])).Value
	return data



def calculate_age(born):
	born = datetime.datetime.strptime(born, '%Y-%m-%d')
	today = datetime.date.today()
	age = today.year - born.year - ((today.month, today.day) < (born.month, born.day))
	age = str(age)[0:10]
	return age