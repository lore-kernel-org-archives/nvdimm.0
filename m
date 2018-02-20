Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0A4B3223C176B
 for <linux-nvdimm@lists.01.org>; Tue, 20 Feb 2018 11:45:19 -0800 (PST)
Date: Tue, 20 Feb 2018 12:51:16 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v6] ndctl: add option to list firmware information for a
 DIMM
Message-ID: <20180220195116.GA1775@linux.intel.com>
References: <151915058813.67767.11669588596758645038.stgit@djiang5-desk3.ch.intel.com>
 <151915070801.67767.2713552470571834771.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151915070801.67767.2713552470571834771.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 20, 2018 at 11:18:28AM -0700, Dave Jiang wrote:
> Adding firmware output of firmware information when ndctl list -D -F is used.
> Components displayed are current firmware version, next firmware version,
> and if a powercycle is required (firmware updated).
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Tested-by: Jeff Moyer <jmoyer@redhat.com>
<>
> +struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
> +		unsigned long flags)
> +{
> +	struct json_object *jfirmware = json_object_new_object();
> +	struct json_object *jobj;
> +	struct ndctl_cmd *cmd;
> +	int rc;
> +	uint64_t run, next;
> +	bool reboot = false;
> +
> +	if (!jfirmware)
> +		return NULL;
> +
> +	cmd = ndctl_dimm_cmd_new_fw_get_info(dimm);
> +	if (!cmd)
> +		goto err;
> +
> +	rc = ndctl_cmd_submit(cmd);
> +	if (rc || ndctl_cmd_fw_xlat_firmware_status(cmd) != FW_SUCCESS) {
> +		int run_err = -1;

Just a few nits.  Looks good otherwise.

This new version defines three different local variables with the value -1
(run_err, run_err, next_err) and uses each one only once.  Can we just use -1
instead of a variable in util_json_object_hex(), or maybe just have one
"error_val" variable that is defined for the whole function?

> +
> +		jobj = util_json_object_hex(run_err, flags);
> +		if (jobj)
> +			json_object_object_add(jfirmware, "current_version",
> +					jobj);
> +		goto out;
> +	}
> +
> +	run = ndctl_cmd_fw_info_get_run_version(cmd);
> +	if (run == ULLONG_MAX) {
> +		int run_err = -1;
> +
> +		jobj = util_json_object_hex(run_err, flags);
> +		if (jobj)
> +			json_object_object_add(jfirmware, "current_version",
> +					jobj);
> +		goto out;
> +	}
> +
> +	jobj = util_json_object_hex(run, flags);
> +	if (jobj)
> +		json_object_object_add(jfirmware, "current_version", jobj);
> +
> +	next = ndctl_cmd_fw_info_get_next_version(cmd);
> +	if (next == ULLONG_MAX) {
> +		int next_err = -1;
> +
> +		jobj = util_json_object_hex(next_err, flags);
> +		if (jobj)
> +			json_object_object_add(jfirmware, "next_version",
> +					jobj);
> +		goto out;
> +	}
> +
> +	if (next != 0) {
> +		reboot = true;
> +		jobj = util_json_object_hex(next, flags);
> +		if (jobj)
> +			json_object_object_add(jfirmware,
> +					"next_version", jobj);
> +	}
> +
> +	if (reboot) {
> +		jobj = json_object_new_boolean(reboot);
> +		if (jobj)
> +			json_object_object_add(jfirmware,
> +					"need_powercycle", jobj);
> +	}

You don't need this 'if (reboot) block' because 'reboot == (next != 0)' - you
can just combine this with the above conditional:

        if (next != 0) {
                jobj = util_json_object_hex(next, flags);
                if (jobj)
                        json_object_object_add(jfirmware,
                                        "next_version", jobj);

                jobj = json_object_new_boolean(true);
                if (jobj)
                        json_object_object_add(jfirmware,
                                        "need_powercycle", jobj);
        }

and you can get rid of the variable 'reboot' entirely.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
