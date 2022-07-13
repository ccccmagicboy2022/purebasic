<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="8608001">
	<Item Name="My Computer" Type="My Computer">
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="LIB" Type="Folder">
			<Item Name="多态函数" Type="Folder">
				<Item Name="bit_access.vi" Type="VI" URL="../LIB/多态函数/bit_access.vi"/>
				<Item Name="driver_status.vi" Type="VI" URL="../LIB/多态函数/driver_status.vi"/>
				<Item Name="plx9054_control.vi" Type="VI" URL="../LIB/多态函数/plx9054_control.vi"/>
				<Item Name="read_io_mem.vi" Type="VI" URL="../LIB/多态函数/read_io_mem.vi"/>
				<Item Name="write_io_mem.vi" Type="VI" URL="../LIB/多态函数/write_io_mem.vi"/>
				<Item Name="card_select.vi" Type="VI" URL="../LIB/多态函数/card_select.vi"/>
			</Item>
			<Item Name="基础函数" Type="Folder">
				<Item Name="PCI通用函数" Type="Folder">
					<Item Name="BIT操作" Type="Folder">
						<Item Name="bit_clear.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/BIT操作/bit_clear.vi"/>
						<Item Name="bit_set.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/BIT操作/bit_set.vi"/>
						<Item Name="MultiBit.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/BIT操作/MultiBit.vi"/>
						<Item Name="read_bit.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/BIT操作/read_bit.vi"/>
					</Item>
					<Item Name="CARD操作" Type="Folder">
						<Item Name="CardInfo.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/CARD操作/CardInfo.vi"/>
						<Item Name="find_resource.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/CARD操作/find_resource.vi"/>
						<Item Name="select_card.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/CARD操作/select_card.vi"/>
						<Item Name="select_plx9054_card.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/CARD操作/select_plx9054_card.vi"/>
					</Item>
					<Item Name="DRIVER状态" Type="Folder">
						<Item Name="cvirte_status.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/driver状态/cvirte_status.vi"/>
						<Item Name="plxapi_status.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/driver状态/plxapi_status.vi"/>
						<Item Name="windriver_status.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/driver状态/windriver_status.vi"/>
					</Item>
					<Item Name="IO操作" Type="Folder">
						<Item Name="CVI_inp_wrapper .vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/IO操作/CVI_inp_wrapper .vi"/>
						<Item Name="CVI_inpd_wrapper.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/IO操作/CVI_inpd_wrapper.vi"/>
						<Item Name="CVI_inpw_wrapper.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/IO操作/CVI_inpw_wrapper.vi"/>
						<Item Name="CVI_outp_wrapper.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/IO操作/CVI_outp_wrapper.vi"/>
						<Item Name="CVI_outpd_wrapper.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/IO操作/CVI_outpd_wrapper.vi"/>
						<Item Name="CVI_outpw_wrapper.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/IO操作/CVI_outpw_wrapper.vi"/>
					</Item>
					<Item Name="MEM操作" Type="Folder">
						<Item Name="Erase_RAM.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/Erase_RAM.vi"/>
						<Item Name="MapPhysicalMemory_wrapper.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/MapPhysicalMemory_wrapper.vi"/>
						<Item Name="PC_PhyRAM_viewer.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/PC_PhyRAM_viewer.vi"/>
						<Item Name="PhyMemAlloc.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/PhyMemAlloc.vi"/>
						<Item Name="PhyMemFree.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/PhyMemFree.vi"/>
						<Item Name="ReadPhyMem16.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/ReadPhyMem16.vi"/>
						<Item Name="ReadPhyMem32.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/ReadPhyMem32.vi"/>
						<Item Name="ReadPhyMem8.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/ReadPhyMem8.vi"/>
						<Item Name="UnMapPhysicalMemory_wrapper.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/UnMapPhysicalMemory_wrapper.vi"/>
						<Item Name="WritePhyMem16.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/WritePhyMem16.vi"/>
						<Item Name="WritePhyMem32.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/WritePhyMem32.vi"/>
						<Item Name="WritePhyMem8.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/MEM操作/WritePhyMem8.vi"/>
					</Item>
					<Item Name="PCR操作" Type="Folder">
						<Item Name="PCR_Read.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/PCR操作/PCR_Read.vi"/>
						<Item Name="PCR_viewer.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/PCR操作/PCR_viewer.vi"/>
						<Item Name="PCR_Write.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/PCR操作/PCR_Write.vi"/>
					</Item>
					<Item Name="地址操作" Type="Folder">
						<Item Name="Address_builder.vi" Type="VI" URL="../LIB/基础函数/PCI通用函数/地址操作/Address_builder.vi"/>
					</Item>
				</Item>
				<Item Name="PLX9054专用函数" Type="Folder">
					<Item Name="EEPROM" Type="Folder">
						<Item Name="EEPROM_viewer.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/EEPROM/EEPROM_viewer.vi"/>
						<Item Name="EraseEeprom.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/EEPROM/EraseEeprom.vi"/>
						<Item Name="IsEepromBlank.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/EEPROM/IsEepromBlank.vi"/>
						<Item Name="IsEepromPresent.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/EEPROM/IsEepromPresent.vi"/>
						<Item Name="LoadDefaultEeprom.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/EEPROM/LoadDefaultEeprom.vi"/>
						<Item Name="ReadEeprom.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/EEPROM/ReadEeprom.vi"/>
						<Item Name="WriteEeprom.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/EEPROM/WriteEeprom.vi"/>
					</Item>
					<Item Name="interrupt_checker.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/interrupt_checker.vi"/>
					<Item Name="IsPlx9054.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/IsPlx9054.vi"/>
					<Item Name="PLX9054_regs.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/PLX9054_regs.vi"/>
					<Item Name="PLX9054_slave_fifo_tester.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/PLX9054_slave_fifo_tester.vi"/>
					<Item Name="PLX9054_slave_ram_tester.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/PLX9054_slave_ram_tester.vi"/>
					<Item Name="ResetCard.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/ResetCard.vi"/>
					<Item Name="ResetCard_ex.vi" Type="VI" URL="../LIB/基础函数/PLX9054专用函数/ResetCard_ex.vi"/>
				</Item>
				<Item Name="配合逻辑设计的函数" Type="Folder">
					<Item Name="CardInfoEx.vi" Type="VI" URL="../LIB/基础函数/配合逻辑设计的函数/CardInfoEx.vi"/>
					<Item Name="DebugControl.vi" Type="VI" URL="../LIB/基础函数/配合逻辑设计的函数/DebugControl.vi"/>
					<Item Name="get_fifo_status.vi" Type="VI" URL="../LIB/基础函数/配合逻辑设计的函数/get_fifo_status.vi"/>
					<Item Name="PCImon.vi" Type="VI" URL="../LIB/基础函数/配合逻辑设计的函数/PCImon.vi"/>
					<Item Name="SpeedTest.vi" Type="VI" URL="../LIB/基础函数/配合逻辑设计的函数/SpeedTest.vi"/>
				</Item>
				<Item Name="serial函数" Type="Folder">
					<Item Name="find_available_serial.vi" Type="VI" URL="../LIB/基础函数/serial函数/find_available_serial.vi"/>
				</Item>
			</Item>
			<Item Name="其它函数" Type="Folder">
				<Item Name="About.vi" Type="VI" URL="../LIB/其它函数/About.vi"/>
				<Item Name="HelloWorldDLL.vi" Type="VI" URL="../LIB/其它函数/HelloWorldDLL.vi"/>
				<Item Name="keypass.vi" Type="VI" URL="../LIB/其它函数/keypass.vi"/>
				<Item Name="count_cvPXILib_functions.vi" Type="VI" URL="../LIB/其它函数/count_cvPXILib_functions.vi"/>
			</Item>
			<Item Name="仪器函数" Type="Folder">
				<Item Name="34410A" Type="Folder">
					<Item Name="read_2lines_res_from_34410A.vi" Type="VI" URL="../LIB/仪器函数/34410A/read_2lines_res_from_34410A.vi"/>
					<Item Name="read_dc_current_from_34410A.vi" Type="VI" URL="../LIB/仪器函数/34410A/read_dc_current_from_34410A.vi"/>
					<Item Name="read_dc_volt_from_34410A.vi" Type="VI" URL="../LIB/仪器函数/34410A/read_dc_volt_from_34410A.vi"/>
				</Item>
				<Item Name="MSO7034B" Type="Folder">
					<Item Name="MSO7034B_Panel.vi" Type="VI" URL="../LIB/仪器函数/MSO7034B/MSO7034B_Panel.vi"/>
					<Item Name="save_screen_to_bmp_mso7034b.vi" Type="VI" URL="../LIB/仪器函数/MSO7034B/save_screen_to_bmp_mso7034b.vi"/>
					<Item Name="save_screen_to_jpg_mso7034b.vi" Type="VI" URL="../LIB/仪器函数/MSO7034B/save_screen_to_jpg_mso7034b.vi"/>
				</Item>
			</Item>
			<Item Name="VISA包装" Type="Folder">
				<Item Name="visa_find_rsrc.vi" Type="VI" URL="../LIB/VISA包装/visa_find_rsrc.vi"/>
				<Item Name="visa_find_rsrc_ex.vi" Type="VI" URL="../LIB/VISA包装/visa_find_rsrc_ex.vi"/>
				<Item Name="phy_mem_alloc_visa.vi" Type="VI" URL="../LIB/VISA包装/phy_mem_alloc_visa.vi"/>
				<Item Name="phy_mem_free_visa.vi" Type="VI" URL="../LIB/VISA包装/phy_mem_free_visa.vi"/>
			</Item>
			<Item Name="共享内存" Type="Folder">
				<Item Name="GetBuffer1_string.vi" Type="VI" URL="../LIB/共享内存/GetBuffer1_string.vi"/>
				<Item Name="SetBuffer1_string.vi" Type="VI" URL="../LIB/共享内存/SetBuffer1_string.vi"/>
				<Item Name="GetBuffer1_double.vi" Type="VI" URL="../LIB/共享内存/GetBuffer1_double.vi"/>
				<Item Name="SetBuffer1_double.vi" Type="VI" URL="../LIB/共享内存/SetBuffer1_double.vi"/>
				<Item Name="GetBuffer1_U32.vi" Type="VI" URL="../LIB/共享内存/GetBuffer1_U32.vi"/>
				<Item Name="SetBuffer1_U32.vi" Type="VI" URL="../LIB/共享内存/SetBuffer1_U32.vi"/>
			</Item>
			<Item Name="WIN32函数" Type="Folder">
				<Item Name="OutputDebugView.vi" Type="VI" URL="../LIB/WIN32函数/OutputDebugView.vi"/>
				<Item Name="CaptureWindow.vi" Type="VI" URL="../LIB/WIN32函数/CaptureWindow.vi"/>
			</Item>
		</Item>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="cvPXILib_LV861" Type="Source Distribution">
				<Property Name="Bld_buildSpecDescription" Type="Str">cvcvcv</Property>
				<Property Name="Bld_buildSpecName" Type="Str">cvPXILib_LV861</Property>
				<Property Name="Bld_excludedDirectory[0]" Type="Path">vi.lib</Property>
				<Property Name="Bld_excludedDirectory[0].pathType" Type="Str">relativeToAppDir</Property>
				<Property Name="Bld_excludedDirectory[1]" Type="Path">resource/objmgr</Property>
				<Property Name="Bld_excludedDirectory[1].pathType" Type="Str">relativeToAppDir</Property>
				<Property Name="Bld_excludedDirectory[2]" Type="Path">instr.lib</Property>
				<Property Name="Bld_excludedDirectory[2].pathType" Type="Str">relativeToAppDir</Property>
				<Property Name="Bld_excludedDirectory[3]" Type="Path">user.lib</Property>
				<Property Name="Bld_excludedDirectory[3].pathType" Type="Str">relativeToAppDir</Property>
				<Property Name="Bld_excludedDirectoryCount" Type="Int">4</Property>
				<Property Name="Destination[0].destName" Type="Str">Destination Directory</Property>
				<Property Name="Destination[0].path" Type="Path">../NI_AB_PROJECTNAME/Release/cvPXILib_LV861</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../NI_AB_PROJECTNAME/Release</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{49F9367B-825C-4D72-B096-7A5DAB3132FC}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].Container.applyInclusion" Type="Bool">true</Property>
				<Property Name="Source[1].Container.applyPassword" Type="Bool">true</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/LIB</Property>
				<Property Name="Source[1].properties[0].type" Type="Str">Password</Property>
				<Property Name="Source[1].properties[0].value" Type="Str">Y3ZHRkdSVGV3cXIzMw==</Property>
				<Property Name="Source[1].propertiesCount" Type="Int">1</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">Include</Property>
				<Property Name="Source[1].type" Type="Str">Container</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
			</Item>
		</Item>
	</Item>
</Project>
