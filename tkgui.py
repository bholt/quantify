#!/usr/bin/env python3

from tkinter import *
from tkinter import filedialog

from util import eval_format as _f

class QuantifyApp:
	def __init__(self, master):
		#root.bind('<Configure>', self.window_callback)
		
		#self.create_toolbar(master)
		
		frame = Frame(master, name='frame')
		frame.pack()
		
		self.text = Text(frame)
		self.text.pack()
		
		self.button = Button(frame, name='hello', text='Hello', command=self.do_something)
		self.button.pack(side=LEFT)
		
		self.create_menu(master)
		
		
	def create_toolbar(self, master):
		toolbar = Frame(root)
		b = Button(toolbar, text='new', width=6, command=self.print_hello)
		b.pack(side=LEFT, padx=2, pady=2)
		
		b = Button(toolbar, text='open', width=6, command=self.print_hello)
		b.pack(side=LEFT, padx=2, pady=2)
		
		toolbar.pack(side=TOP, fill=X)
	
	def create_menu(self, master):
		menu = Menu(master)
		root.config(menu=menu)
		filemenu = Menu(menu)
		menu.add_cascade(label='File',menu=filemenu)
		filemenu.add_command(label='New', command=self.print_hello)
		filemenu.add_separator()
		filemenu.add_command(label='Open', command=self.get_filename)
		helpmenu = Menu(menu)
		menu.add_cascade(label='Help',menu=helpmenu)
		helpmenu.add_command(label='Help', command=self.print_hello)
		
	def print_hello(self):
		print('Hello!')	
	
	def window_callback(self, event):
		print(_f('{event.widget} resized ({event.width}, {event.height})'))
		return 'break'
		
	def get_filename(self):
		fname = filedialog.askopenfilename(title='quantify - Open')
		print(_f("Opening {fname}"))
		
	def do_something(self):
		print('Hello world!')



if __name__ == '__main__':
	root = Tk()
	app = QuantifyApp(root)
	root.mainloop()