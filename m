Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 257D7211B76AA
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 10:04:59 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: ndctl v64 stage tree -- Re: [PATCH v7 00/12] ndctl: add
 security support
Date: Wed, 16 Jan 2019 18:04:51 +0000
Message-ID: <b122c47b2607b8a7a45dff47c23853c7009b0fb6.camel@intel.com>
References: <154705633843.23227.15903675663299735878.stgit@djiang5-desk3.ch.intel.com>
 <5b9f677a-2a6b-f999-ff3e-7a8ec8938868@oracle.com>
 <3412a217ab51c55878362f28e40ed058c69148a8.camel@intel.com>
 <b5e2bc32-127f-50c0-2728-ec81a9a47413@oracle.com>
In-Reply-To: <b5e2bc32-127f-50c0-2728-ec81a9a47413@oracle.com>
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
To: "jane.chu@oracle.com" <jane.chu@oracle.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-01-16 at 10:02 -0800, Jane Chu wrote:

Hi, Vishal,


On 1/11/2019 3:36 PM, Verma, Vishal L wrote:

On Fri, 2019-01-11 at 15:18 -0800, Jane Chu wrote:


Hi, Dave,


Where is your ndctl git tree that might clone from to test the

security features?


Hi Jane,


I pushed out a for-v64-security branch with this (v7) series:


https://github.com/pmem/ndctl/tree/for-v64-security


I believe Dave plans to have v8 out early next week with a few changes,

most notably the loadkeys script becomes a first class ndctl command.

Just thought I might get a quick answer here although I haven't

gone thru all my homework.


I'm seeing "FAIL: security.sh" from "make KVER=5.0.0 check" on a NVDIMM system,

the security.sh.log indicates


+ '[' '!' -f /usr/bin/keyctl ']'

+ '[' '!' -d /etc/ndctl/keys ']'

+ echo '/etc/ndctl/keys directory does not exist.'

/etc/ndctl/keys directory does not exist.

+ exit 1


Indeed, what step did I miss?

Hi Jane,

I ran into a similar problem running the test, and indeed a few others after you fix this. We should have a new revision out soon that addresses these.

-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
