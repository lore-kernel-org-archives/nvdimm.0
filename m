Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D8D921A143EF
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jul 2018 16:34:52 -0700 (PDT)
Received: from G4W9120.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
 [16.210.21.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2354.austin.hpe.com (Postfix) with ESMTPS id 3CB7A1A1
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jul 2018 23:34:50 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: ndctl read-labels default output format
Date: Tue, 10 Jul 2018 23:34:44 +0000
Message-ID: <DF4PR8401MB11805E09ADFA9532FBF689FAAB5B0@DF4PR8401MB1180.NAMPRD84.PROD.OUTLOOK.COM>
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
To: 'Dan Williams' <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Dan Williams
> Sent: Saturday, April 9, 2016 2:40 PM
> To: linux-nvdimm@lists.01.org
> Subject: [ndctl PATCH 3/4] ndctl: new 'read-labels' utility
> 
> For debug, it is useful to be able to dump the label area of a dimm.
...
> +ndctl-read-labels - read out the label area on a dimm or set of dimms
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl read-labels' <nmem0> [<nmem1>..<nmemN>] [<options>]
> +
> +include::labels-description.txt[]
> +This command dumps the raw binary data in a dimm's label area to stdout or a
> +file.  In the multi-dimm case the data is concatenated.
> +
> +OPTIONS
> +-------
> +include::labels-options.txt[]
> +-o::
> +	output file
> +-j::
> +--json::
> +	parse the label data into json assuming the 'NVDIMM Namespace
> +	Specification' format.
> +

Most ndctl commands output JSON.  This one is a bit unfriendly in dumping
binary data.  Could -j be the default mode (possibly also supporting the
-u/--human option)?

Also, it prints "read %d nmems" to stderr. That doesn't mess up piping
stdout to another tool like jq, but does mess up cutting-and-pasting
the console output and feeding it to another tool.  Could that line
be dropped?  Keep the similar prints for commands that request actions
rather than print information.

---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
