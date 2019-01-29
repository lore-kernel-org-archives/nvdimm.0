Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA4FE2194D3AE
 for <linux-nvdimm@lists.01.org>; Tue, 29 Jan 2019 08:27:41 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v4 1/5] libndctl: Use the supported_alignment attribute
Date: Tue, 29 Jan 2019 16:27:36 +0000
Message-ID: <AT5PR8401MB1169AFF96ACEB871BED4DE39AB970@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190129144857.6741-1-oohall@gmail.com>
In-Reply-To: <20190129144857.6741-1-oohall@gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Oliver O'Halloran
> Sent: Tuesday, January 29, 2019 8:49 AM
> To: linux-nvdimm@lists.01.org
> Subject: [PATCH v4 1/5] libndctl: Use the supported_alignment attribute
> 
>     Reworded comment about why we default to 4K and 2M alignments when
>     the sysfs attribute is missing.
...
> +	/*
> +	 * The supported_alignments attribute was added before arches other
> +	 * than x86 had pmem support. If the kernel doesn't provide the
> +	 * attribute then it's safe to a attribute then it's safe to assume
> +	 * that we are on x86 which will always support 2MB and 4KB

"then it's safe to a attribute" is extraneous.

Also, please use MiB and KiB everywhere.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
