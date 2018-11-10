Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7BE732118EF74
 for <linux-nvdimm@lists.01.org>; Fri,  9 Nov 2018 18:59:42 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 07/11] libnvdimm/security: add overwrite status
 notification
Date: Sat, 10 Nov 2018 02:59:38 +0000
Message-ID: <AT5PR8401MB116956C2607922D6BB9B1AC1ABC70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180166375.70506.1085533195452285285.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154180166375.70506.1085533195452285285.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "zohar@linux.vnet.ibm.com" <zohar@linux.vnet.ibm.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of
> Dave Jiang
> Sent: Friday, November 09, 2018 4:14 PM
> Subject: [PATCH 07/11] libnvdimm/security: add overwrite status
> notification
> 
...
> @@ -2033,6 +2033,11 @@ static int acpi_nfit_register_dimms(struct
> acpi_nfit_desc *acpi_desc)
>  		if (!nvdimm)
>  			continue;
> 
> +		rc = nvdimm_setup_security_events(nvdimm);
> +		if (rc < 0)
> +			dev_warn(acpi_desc->dev,
> +					"no security event setup
> failed\n");

That seems like a double negative.

Printing the rc value (or better yet, the string for it)
is always helpful too.

---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
