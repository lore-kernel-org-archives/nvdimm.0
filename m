Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2318221250CB6
 for <linux-nvdimm@lists.01.org>; Mon,  6 May 2019 14:50:08 -0700 (PDT)
Subject: Re: [ndctl PATCH 0/8] daxctl: add a new reconfigure-device command
References: <20190503213231.12280-1-vishal.l.verma@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <12edf619-be22-8ae9-77c0-8a81cb353a87@intel.com>
Date: Mon, 6 May 2019 14:50:07 -0700
MIME-Version: 1.0
In-Reply-To: <20190503213231.12280-1-vishal.l.verma@intel.com>
Content-Language: en-US
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
To: Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>
List-ID: <linux-nvdimm@lists.01.org>

This all looks quite nice to me.  Thanks, Vishal!

One minor nit: for those of us new to daxctl and friends, they can be a
bit hard to get started with.  Could you maybe add a few example
invocations to the Documentation, or even this cover letter to help us
newbies get started?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
