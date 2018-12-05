Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5122421196236
 for <linux-nvdimm@lists.01.org>; Wed,  5 Dec 2018 12:42:50 -0800 (PST)
Date: Wed, 5 Dec 2018 21:42:47 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [mm PATCH v6 6/7] mm: Add reserved flag setting to set_page_links
Message-ID: <20181205204247.GY1286@dhcp22.suse.cz>
References: <154361452447.7497.1348692079883153517.stgit@ahduyck-desk1.amr.corp.intel.com>
 <154361479877.7497.2824031260670152276.stgit@ahduyck-desk1.amr.corp.intel.com>
 <20181205172225.GT1286@dhcp22.suse.cz>
 <19c9f0fe83a857d5858c386a08ca2ddeba7cf27b.camel@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <19c9f0fe83a857d5858c386a08ca2ddeba7cf27b.camel@linux.intel.com>
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, mingo@kernel.org, linux-mm@kvack.org, khalid.aziz@oracle.com, rppt@linux.vnet.ibm.com, vbabka@suse.cz, sparclinux@vger.kernel.org, akpm@linux-foundation.org, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, davem@davemloft.net, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed 05-12-18 09:55:17, Alexander Duyck wrote:
> On Wed, 2018-12-05 at 18:22 +0100, Michal Hocko wrote:
> > On Fri 30-11-18 13:53:18, Alexander Duyck wrote:
> > > Modify the set_page_links function to include the setting of the reserved
> > > flag via a simple AND and OR operation. The motivation for this is the fact
> > > that the existing __set_bit call still seems to have effects on performance
> > > as replacing the call with the AND and OR can reduce initialization time.
> > > 
> > > Looking over the assembly code before and after the change the main
> > > difference between the two is that the reserved bit is stored in a value
> > > that is generated outside of the main initialization loop and is then
> > > written with the other flags field values in one write to the page->flags
> > > value. Previously the generated value was written and then then a btsq
> > > instruction was issued.
> > > 
> > > On my x86_64 test system with 3TB of persistent memory per node I saw the
> > > persistent memory initialization time on average drop from 23.49s to
> > > 19.12s per node.
> > 
> > I have tried to explain why the whole reserved bit doesn't make much
> > sense in this code several times already. You keep ignoring that and
> > that is highly annoying. Especially when you add a tricky code to
> > optimize something that is not really needed.
> > 
> > Based on that I am not going to waste my time on other patches in this
> > series to review and give feedback which might be ignored again.
> 
> I got your explanation. However Andrew had already applied the patches
> and I had some outstanding issues in them that needed to be addressed.
> So I thought it best to send out this set of patches with those fixes
> before the code in mm became too stale. I am still working on what to
> do about the Reserved bit, and plan to submit it as a follow-up set.

>From my experience Andrew can drop patches between different versions of
the patchset. Things can change a lot while they are in mmotm and under
the discussion.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
