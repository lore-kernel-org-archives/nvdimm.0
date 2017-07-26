Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1694021D091AB
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 11:46:28 -0700 (PDT)
From: Linda Knippers <linda.knippers@hpe.com>
Subject: ndctl: 10G not a multiple of 2M?
Message-ID: <5978E3D3.5020307@hpe.com>
Date: Wed, 26 Jul 2017 14:47:47 -0400
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I was creating a namespace on a 4-way interleave set and got an error
I didn't expect:

$ sudo ndctl create-namespace -m sector -s 10G -n number2
  Error: '--size=' must align to interleave-width: 4 and alignment: 2097152
  did you intend --size=12G?

I think there's a bug in validate_namespace_options().

What's happening is that since I specified my size in units of G,
the function wants the namespace to be 1G * 4 aligned rather than
2M * 4 aligned.  I suspect if I specified my size in M, it would
have worked but I can't test that at the moment.

>  size_align = max(units, size_align) * ways;

Why is units part of the equation?

-- ljk
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
