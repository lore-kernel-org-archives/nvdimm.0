Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05FFD2117D741
 for <linux-nvdimm@lists.01.org>; Tue, 23 Oct 2018 11:16:52 -0700 (PDT)
Subject: Re: [PATCH 0/9] Allow persistent memory to be used like normal RAM
References: <20181022201317.8558C1D8@viggo.jf.intel.com>
 <CAPcyv4hxs-GnmwQU1wPZyg5aydCY5K09-YpSrrLpvU1v_8dbBw@mail.gmail.com>
 <AT5PR8401MB11694012893ED2121D7A345EABF50@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <2677a7f9-5dc8-7590-2b8b-a67da1cb6b92@intel.com>
Date: Tue, 23 Oct 2018 11:16:52 -0700
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB11694012893ED2121D7A345EABF50@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, 'Dan Williams' <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, "Hocko, Michal" <MHocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "zwisler@kernel.org" <zwisler@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, "Huang, Ying" <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

>> This series adds a new "driver" to which pmem devices can be
>> attached.  Once attached, the memory "owned" by the device is
>> hot-added to the kernel and managed like any other memory.  On
> 
> Would this memory be considered volatile (with the driver initializing
> it to zeros), or persistent (contents are presented unchanged,
> applications may guarantee persistence by using cache flush
> instructions, fence instructions, and writing to flush hint addresses
> per the persistent memory programming model)?

Volatile.

>> I expect udev can automate this by setting up a rule to watch for
>> device-dax instances by UUID and call a script to do the detach /
>> reattach dance.
> 
> Where would that rule be stored? Storing it on another device
> is problematic. If that rule is lost, it could confuse other
> drivers trying to grab device DAX devices for use as persistent
> memory.

Well, we do lots of things like stable device naming from udev scripts.
 We depend on them not being lost.  At least this "fails safe" so we'll
default to persistence instead of defaulting to "eat your data".

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
