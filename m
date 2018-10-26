Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 904CE2117FD7D
 for <linux-nvdimm@lists.01.org>; Fri, 26 Oct 2018 06:58:10 -0700 (PDT)
Subject: Re: [PATCH 0/9] Allow persistent memory to be used like normal RAM
References: <20181022201317.8558C1D8@viggo.jf.intel.com>
 <CAPcyv4hxs-GnmwQU1wPZyg5aydCY5K09-YpSrrLpvU1v_8dbBw@mail.gmail.com>
 <CAPcyv4hFoPkda0YfNKo=nFxttyBG3OjD7vKWyNzLY+8T5gLc=g@mail.gmail.com>
 <352acc87-a6da-65e4-bbe6-0dbffdc72acc@gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <b6239107-3c49-8041-babd-844eef84c361@intel.com>
Date: Fri, 26 Oct 2018 06:58:08 -0700
MIME-Version: 1.0
In-Reply-To: <352acc87-a6da-65e4-bbe6-0dbffdc72acc@gmail.com>
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
To: Xishi Qiu <qiuxishi@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Michal Hocko <mhocko@suse.com>, Xishi Qiu <qiuxishi@linux.alibaba.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Huang, Ying" <ying.huang@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, zy107165@alibaba-inc.com, zwisler@kernel.org, Andrew Morton <akpm@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 10/26/18 1:03 AM, Xishi Qiu wrote:
> How about let the BIOS report a new type for kmem in e820 table?
> e.g.
> #define E820_PMEM	7
> #define E820_KMEM	8

It would be best if the BIOS just did this all for us.  But, what you're
describing would take years to get from concept to showing up in
someone's hands.  I'd rather not wait.

Plus, doing it the way I suggested gives the OS the most control.  The
BIOS isn't in the critical path to do the right thing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
