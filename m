Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C3C3211D35CE
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 09:33:09 -0700 (PDT)
Date: Wed, 13 Mar 2019 09:33:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mm PATCH v6 6/7] mm: Add reserved flag setting to set_page_links
Message-Id: <20190313093306.c4b49c6d062f506a967f843d@linux-foundation.org>
In-Reply-To: <4c72a04bb87e341ea7c747d509f42136a99a0716.camel@linux.intel.com>
References: <154361452447.7497.1348692079883153517.stgit@ahduyck-desk1.amr.corp.intel.com>
 <154361479877.7497.2824031260670152276.stgit@ahduyck-desk1.amr.corp.intel.com>
 <20181205172225.GT1286@dhcp22.suse.cz>
 <19c9f0fe83a857d5858c386a08ca2ddeba7cf27b.camel@linux.intel.com>
 <20181205204247.GY1286@dhcp22.suse.cz>
 <20190312150727.cb15cbc323a742e520b9a881@linux-foundation.org>
 <4c72a04bb87e341ea7c747d509f42136a99a0716.camel@linux.intel.com>
Mime-Version: 1.0
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
Cc: mingo@kernel.org, pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, khalid.aziz@oracle.com, rppt@linux.vnet.ibm.com, vbabka@suse.cz, sparclinux@vger.kernel.org, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, davem@davemloft.net, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 12 Mar 2019 15:50:36 -0700 Alexander Duyck <alexander.h.duyck@linux.intel.com> wrote:

> On Tue, 2019-03-12 at 15:07 -0700, Andrew Morton wrote:
> > On Wed, 5 Dec 2018 21:42:47 +0100 Michal Hocko <mhocko@kernel.org> wrote:
> > 
> > > > I got your explanation. However Andrew had already applied the patches
> > > > and I had some outstanding issues in them that needed to be addressed.
> > > > So I thought it best to send out this set of patches with those fixes
> > > > before the code in mm became too stale. I am still working on what to
> > > > do about the Reserved bit, and plan to submit it as a follow-up set.
> > > > From my experience Andrew can drop patches between different versions of
> > > the patchset. Things can change a lot while they are in mmotm and under
> > > the discussion.
> > 
> > It's been a while and everyone has forgotten everything, so I'll drop
> > this version of the patchset.
> > 
> 
> As far as getting to the reserved bit I probably won't have the time in
> the near future. If I were to resubmit the first 4 patches as a
> standalone patch set would that be acceptable, or would they be held up
> as well until the reserved bit issues is addressed?
> 

Yes, I think that merging the first four will be OK.  As long as they
don't add some bug which [5/5] corrects, which happens sometimes!

Please redo, retest and resend sometime?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
