Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 39BAA21BADAB2
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 10:02:50 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v5 01/12] nfit: add support for Intel DSM 1.7 commands
Date: Wed, 18 Jul 2018 17:02:31 +0000
Message-ID: <AT5PR8401MB1169A89CE1A16C991D958720AB530@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <153186084980.27463.13636864614684009370.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153186084980.27463.13636864614684009370.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: 'Dave Jiang' <dave.jiang@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "dhowells@redhat.com" <dhowells@redhat.com>, "alison.schofield@intel.com" <alison.schofield@intel.com>, "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Dave Jiang
> Sent: Tuesday, July 17, 2018 3:54 PM
> Subject: [PATCH v5 01/12] nfit: add support for Intel DSM 1.7 commands
...
> +#ifdef CONFIG_X86
> +
> +#define ND_INTEL_STATUS_SIZE		4
> +#define ND_INTEL_PASSPHRASE_SIZE	32
> +
...
> +
> +struct nd_intel_get_security_state {
> +	u32 status;
> +	u32 reserved;
> +	u8 state;
> +	u8 reserved1[3];
> +} __packed;
> +
> +struct nd_intel_set_passphrase {
> +	u8 old_pass[32];
> +	u8 new_pass[32];
> +	u32 status;
> +} __packed;
> +
> +struct nd_intel_unlock_unit {
> +	u8 passphrase[32];
> +	u32 status;
> +} __packed;
> +
> +struct nd_intel_disable_passphrase {
> +	u8 passphrase[32];
> +	u32 status;
> +} __packed;
> +
> +struct nd_intel_freeze_lock {
> +	u32 status;
> +} __packed;
> +
> +struct nd_intel_secure_erase {
> +	u8 passphrase[32];
> +	u32 status;
> +} __packed;
> +
> +struct nd_intel_overwrite {
> +	u8 passphrase[32];
> +	u32 status;
> +} __packed;

All those should use ND_INTEL_PASSPHRASE_SIZE rather than 32,
or there should be a compile-time check that the macro is
<= 32.

In patch 06/12, there is a lot of code that uses
ND_INTEL_PASSPHRASE_SIZE like this:

> +	if (old_data)
> +		memcpy(nd_cmd.cmd.old_pass, old_data->data,
> +				ND_INTEL_PASSPHRASE_SIZE);
> +	memcpy(nd_cmd.cmd.new_pass, new_data->data, ND_INTEL_PASSPHRASE_SIZE);

I think it's safer to use sizeof the destination field:

+	if (old_data)
+		memcpy(nd_cmd.cmd.old_pass, old_data->data,
+				sizeof(nd_cmd.cmd.old_pass));
+	memcpy(nd_cmd.cmd.new_pass, new_data->data,
	       sizeof(nd_cmd.cmd.new_pass));

That helps if the macro gets out of sync with the real size of
the structure.  If it larger, this change prevents an overrun.  If
it is smaller, then memcpy copies some extra bytes, which is
harmless.


---
Robert Elliott, HPE Persistent Memory





_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
