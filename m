Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1718D211D38FD
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 10:07:39 -0700 (PDT)
Message-ID: <e1d108a27d8f532e147c860ee64db6a07ed87040.camel@linux.intel.com>
Subject: Re: [mm PATCH v6 6/7] mm: Add reserved flag setting to set_page_links
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Wed, 13 Mar 2019 10:07:39 -0700
In-Reply-To: <20190313093306.c4b49c6d062f506a967f843d@linux-foundation.org>
References: <154361452447.7497.1348692079883153517.stgit@ahduyck-desk1.amr.corp.intel.com>
 <154361479877.7497.2824031260670152276.stgit@ahduyck-desk1.amr.corp.intel.com>
 <20181205172225.GT1286@dhcp22.suse.cz>
 <19c9f0fe83a857d5858c386a08ca2ddeba7cf27b.camel@linux.intel.com>
 <20181205204247.GY1286@dhcp22.suse.cz>
 <20190312150727.cb15cbc323a742e520b9a881@linux-foundation.org>
 <4c72a04bb87e341ea7c747d509f42136a99a0716.camel@linux.intel.com>
 <20190313093306.c4b49c6d062f506a967f843d@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@kernel.org, pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, khalid.aziz@oracle.com, rppt@linux.vnet.ibm.com, vbabka@suse.cz, sparclinux@vger.kernel.org, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, davem@davemloft.net, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2019-03-13 at 09:33 -0700, Andrew Morton wrote:
> On Tue, 12 Mar 2019 15:50:36 -0700 Alexander Duyck <alexander.h.duyck@linux.intel.com> wrote:
> 
> > On Tue, 2019-03-12 at 15:07 -0700, Andrew Morton wrote:
> > > On Wed, 5 Dec 2018 21:42:47 +0100 Michal Hocko <mhocko@kernel.org> wrote:
> > > 
> > > > > I got your explanation. However Andrew had already applied the patches
> > > > > and I had some outstanding issues in them that needed to be addressed.
> > > > > So I thought it best to send out this set of patches with those fixes
> > > > > before the code in mm became too stale. I am still working on what to
> > > > > do about the Reserved bit, and plan to submit it as a follow-up set.
> > > > > From my experience Andrew can drop patches between different versions of
> > > > the patchset. Things can change a lot while they are in mmotm and under
> > > > the discussion.
> > > 
> > > It's been a while and everyone has forgotten everything, so I'll drop
> > > this version of the patchset.
> > > 
> > 
> > As far as getting to the reserved bit I probably won't have the time in
> > the near future. If I were to resubmit the first 4 patches as a
> > standalone patch set would that be acceptable, or would they be held up
> > as well until the reserved bit issues is addressed?
> > 
> 
> Yes, I think that merging the first four will be OK.  As long as they
> don't add some bug which [5/5] corrects, which happens sometimes!
> 
> Please redo, retest and resend sometime?

I had gone through and tested with each patch applied individually when
I was performance testing them, and I am fairly certain there wasn't a
bug introduced between any two patches.

The issue that I recall Michal had was the fact that I was essentially
embedding the setting of the reserved page under several layers of
function calls, which would make it harder to remove. I started that
work at about patch 5 which is why I figured I would resend the first
4, and hold off on 5-7 until I can get the reserved bit removal for
hotplug done.

I can probably have the patches ready to go in a couple days. I'll send
updates once linux-next and mmotm with the patches dropped have been
posted.

Thanks.

- Alex

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
