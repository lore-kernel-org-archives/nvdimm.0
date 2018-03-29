Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7D68225501D0
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 15:56:07 -0700 (PDT)
Received: by mail-ot0-x233.google.com with SMTP id i28-v6so8013419otf.8
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 16:02:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180329160215.glnrmyunujcc4vwg@quack2.suse.cz>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167306807.5268.8483232024444414342.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180329160215.glnrmyunujcc4vwg@quack2.suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Mar 2018 16:02:45 -0700
Message-ID: <CAPcyv4jK92ev=yWaKCUdxN5z+4+feH+ts3j6KHk57bZVu_QqYQ@mail.gmail.com>
Subject: Re: [PATCH v7 07/14] fs, dax: use page->mapping to warn if truncate
 collides with a busy page
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
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 29, 2018 at 9:02 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 21-03-18 15:57:48, Dan Williams wrote:
[..]
> I find it quite tricky that in case we pass zero page / empty entry into
> dax_[dis]associate_entry(), it will not do anything because
> dax_entry_size() will return 0. Can we add an explicit check into
> dax_[dis]associate_entry() or at least a comment there?

How about the following, i.e. rename the loop helper to
for_each_dax_pfn() to make it clearer that we're only operating on
mapped pfns, and also add a comment to indicate the same:

/*
 * Iterate through all mapped pfns represented by an entry, i.e. skip
 * 'empty' and 'zero' entries.
 */
#define for_each_dax_pfn(entry, pfn) \
        for (pfn = dax_radix_pfn(entry); \
                        pfn < dax_radix_end_pfn(entry); pfn++)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
