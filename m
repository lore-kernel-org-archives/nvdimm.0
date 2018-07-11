Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D68B22096F33E
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 02:08:04 -0700 (PDT)
Date: Wed, 11 Jul 2018 12:07:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] acpi/nfit: fix cmd_rc for acpi_nfit_ctl to always
 return a value
Message-ID: <20180711090752.6elandgsvgs5taqu@kili.mountain>
MIME-Version: 1.0
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dave.jiang@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello Dave Jiang,

This is a semi-automatic email about new static checker warnings.

The patch c1985cefd844: "acpi/nfit: fix cmd_rc for acpi_nfit_ctl to 
always return a value" from Jun 28, 2018, leads to the following 
Smatch complaint:

    drivers/acpi/nfit/core.c:578 acpi_nfit_ctl()
     warn: variable dereferenced before check 'cmd_rc' (see line 411)

drivers/acpi/nfit/core.c
   410	
   411		*cmd_rc = -EINVAL;
                ^^^^^^^^^^^^^^^^^^
Patch adds unchecked dereference.

   412		func = cmd;
   413		if (cmd == ND_CMD_CALL) {
   414			call_pkg = buf;
   415			func = call_pkg->nd_command;
   416	
   417			for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
   418				if (call_pkg->nd_reserved2[i])
   419					return -EINVAL;
   420		}
   421	
   422		if (nvdimm) {
   423			struct acpi_device *adev = nfit_mem->adev;
   424	
   425			if (!adev)
   426				return -ENOTTY;
   427			if (call_pkg && nfit_mem->family != call_pkg->nd_family)
   428				return -ENOTTY;
   429	
   430			dimm_name = nvdimm_name(nvdimm);
   431			cmd_name = nvdimm_cmd_name(cmd);
   432			cmd_mask = nvdimm_cmd_mask(nvdimm);
   433			dsm_mask = nfit_mem->dsm_mask;
   434			desc = nd_cmd_dimm_desc(cmd);
   435			guid = to_nfit_uuid(nfit_mem->family);
   436			handle = adev->handle;
   437		} else {
   438			struct acpi_device *adev = to_acpi_dev(acpi_desc);
   439	
   440			cmd_name = nvdimm_bus_cmd_name(cmd);
   441			cmd_mask = nd_desc->cmd_mask;
   442			dsm_mask = cmd_mask;
   443			if (cmd == ND_CMD_CALL)
   444				dsm_mask = nd_desc->bus_dsm_mask;
   445			desc = nd_cmd_bus_desc(cmd);
   446			guid = to_nfit_uuid(NFIT_DEV_BUS);
   447			handle = adev->handle;
   448			dimm_name = "bus";
   449		}
   450	
   451		if (!desc || (cmd && (desc->out_num + desc->in_num == 0)))
   452			return -ENOTTY;
   453	
   454		if (!test_bit(cmd, &cmd_mask) || !test_bit(func, &dsm_mask))
   455			return -ENOTTY;
   456	
   457		in_obj.type = ACPI_TYPE_PACKAGE;
   458		in_obj.package.count = 1;
   459		in_obj.package.elements = &in_buf;
   460		in_buf.type = ACPI_TYPE_BUFFER;
   461		in_buf.buffer.pointer = buf;
   462		in_buf.buffer.length = 0;
   463	
   464		/* libnvdimm has already validated the input envelope */
   465		for (i = 0; i < desc->in_num; i++)
   466			in_buf.buffer.length += nd_cmd_in_size(nvdimm, cmd, desc,
   467					i, buf);
   468	
   469		if (call_pkg) {
   470			/* skip over package wrapper */
   471			in_buf.buffer.pointer = (void *) &call_pkg->nd_payload;
   472			in_buf.buffer.length = call_pkg->nd_size_in;
   473		}
   474	
   475		dev_dbg(dev, "%s cmd: %d: func: %d input length: %d\n",
   476			dimm_name, cmd, func, in_buf.buffer.length);
   477		print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
   478				in_buf.buffer.pointer,
   479				min_t(u32, 256, in_buf.buffer.length), true);
   480	
   481		/* call the BIOS, prefer the named methods over _DSM if available */
   482		if (nvdimm && cmd == ND_CMD_GET_CONFIG_SIZE && nfit_mem->has_lsr)
   483			out_obj = acpi_label_info(handle);
   484		else if (nvdimm && cmd == ND_CMD_GET_CONFIG_DATA && nfit_mem->has_lsr) {
   485			struct nd_cmd_get_config_data_hdr *p = buf;
   486	
   487			out_obj = acpi_label_read(handle, p->in_offset, p->in_length);
   488		} else if (nvdimm && cmd == ND_CMD_SET_CONFIG_DATA
   489				&& nfit_mem->has_lsw) {
   490			struct nd_cmd_set_config_hdr *p = buf;
   491	
   492			out_obj = acpi_label_write(handle, p->in_offset, p->in_length,
   493					p->in_buf);
   494		} else {
   495			u8 revid;
   496	
   497			if (nvdimm)
   498				revid = nfit_dsm_revid(nfit_mem->family, func);
   499			else
   500				revid = 1;
   501			out_obj = acpi_evaluate_dsm(handle, guid, revid, func, &in_obj);
   502		}
   503	
   504		if (!out_obj) {
   505			dev_dbg(dev, "%s _DSM failed cmd: %s\n", dimm_name, cmd_name);
   506			return -EINVAL;
   507		}
   508	
   509		if (call_pkg) {
   510			call_pkg->nd_fw_size = out_obj->buffer.length;
   511			memcpy(call_pkg->nd_payload + call_pkg->nd_size_in,
   512				out_obj->buffer.pointer,
   513				min(call_pkg->nd_fw_size, call_pkg->nd_size_out));
   514	
   515			ACPI_FREE(out_obj);
   516			/*
   517			 * Need to support FW function w/o known size in advance.
   518			 * Caller can determine required size based upon nd_fw_size.
   519			 * If we return an error (like elsewhere) then caller wouldn't
   520			 * be able to rely upon data returned to make calculation.
   521			 */
   522			*cmd_rc = 0;
   523			return 0;
   524		}
   525	
   526		if (out_obj->package.type != ACPI_TYPE_BUFFER) {
   527			dev_dbg(dev, "%s unexpected output object type cmd: %s type: %d\n",
   528					dimm_name, cmd_name, out_obj->type);
   529			rc = -EINVAL;
   530			goto out;
   531		}
   532	
   533		dev_dbg(dev, "%s cmd: %s output length: %d\n", dimm_name,
   534				cmd_name, out_obj->buffer.length);
   535		print_hex_dump_debug(cmd_name, DUMP_PREFIX_OFFSET, 4, 4,
   536				out_obj->buffer.pointer,
   537				min_t(u32, 128, out_obj->buffer.length), true);
   538	
   539		for (i = 0, offset = 0; i < desc->out_num; i++) {
   540			u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i, buf,
   541					(u32 *) out_obj->buffer.pointer,
   542					out_obj->buffer.length - offset);
   543	
   544			if (offset + out_size > out_obj->buffer.length) {
   545				dev_dbg(dev, "%s output object underflow cmd: %s field: %d\n",
   546						dimm_name, cmd_name, i);
   547				break;
   548			}
   549	
   550			if (in_buf.buffer.length + offset + out_size > buf_len) {
   551				dev_dbg(dev, "%s output overrun cmd: %s field: %d\n",
   552						dimm_name, cmd_name, i);
   553				rc = -ENXIO;
   554				goto out;
   555			}
   556			memcpy(buf + in_buf.buffer.length + offset,
   557					out_obj->buffer.pointer + offset, out_size);
   558			offset += out_size;
   559		}
   560	
   561		/*
   562		 * Set fw_status for all the commands with a known format to be
   563		 * later interpreted by xlat_status().
   564		 */
   565		if (i >= 1 && ((!nvdimm && cmd >= ND_CMD_ARS_CAP
   566						&& cmd <= ND_CMD_CLEAR_ERROR)
   567					|| (nvdimm && cmd >= ND_CMD_SMART
   568						&& cmd <= ND_CMD_VENDOR)))
   569			fw_status = *(u32 *) out_obj->buffer.pointer;
   570	
   571		if (offset + in_buf.buffer.length < buf_len) {
   572			if (i >= 1) {
   573				/*
   574				 * status valid, return the number of bytes left
   575				 * unfilled in the output buffer
   576				 */
   577				rc = buf_len - offset - in_buf.buffer.length;
   578				if (cmd_rc)
                                    ^^^^^^
Checked too late.

   579					*cmd_rc = xlat_status(nvdimm, buf, cmd,
   580							fw_status);

regards,
dan carpenter
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
