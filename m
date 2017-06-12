Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 24EEB21A16EDD
 for <linux-nvdimm@lists.01.org>; Sun, 11 Jun 2017 21:01:25 -0700 (PDT)
Date: Sun, 11 Jun 2017 22:02:36 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/3] mm: add vm_insert_mixed_mkwrite()
Message-ID: <20170612040236.GA7352@linux.intel.com>
References: <20170607204859.13104-1-ross.zwisler@linux.intel.com>
 <CAA9_cmcPsyZCB7-pd9djL0+bLamfL49SJVgkyoJ22G6tgOxyww@mail.gmail.com>
 <20170610030346.GA3575@linux.intel.com>
 <CAPcyv4jsgUfL5Cr5a342aVNKXBrtXzpuar_1U3w3auHoT2E08A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jsgUfL5Cr5a342aVNKXBrtXzpuar_1U3w3auHoT2E08A@mail.gmail.com>
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
Cc: Dave Hansen <dave.hansen@intel.com>, Jonathan Corbet <corbet@lwn.net>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, ext4 hackers <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 09, 2017 at 08:35:08PM -0700, Dan Williams wrote:
> On Fri, Jun 9, 2017 at 8:03 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > And vm_insert_mixed_mkwrite() and vm_insert_mixed() are redundant with only
> > the insert_pfn() line differing?  This doesn't seem better...unless I'm
> > missing something?
> >
> > The way it is, vm_insert_mixed_mkwrite() also closely matches
> > insert_pfn_pmd(), which we use in the PMD case and which also takes a 'write'
> > boolean which works the same as our newly added 'mkwrite'.
> 
> Hmm, but now the pfn and pmd cases are inconsistent, if you put the
> flag name in the function then don't add an argument, or make it like
> the pmd case and add an argument to vm_insert_mixed(). I prefer the
> former.

Okay, I'll fix this for v2.  Thanks for the review.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
