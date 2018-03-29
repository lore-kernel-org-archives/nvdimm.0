Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22a.google.com (mail-ot0-x22a.google.com
 [IPv6:2607:f8b0:4003:c0f::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD01A225501C5
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 15:41:16 -0700 (PDT)
Received: by mail-ot0-x22a.google.com with SMTP id p33-v6so1718225otp.11
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 15:47:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180329180927.GA16055@lst.de>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152167305782.5268.13485258587227210521.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180329154035.lvsepjvt6vcplshw@quack2.suse.cz>
 <20180329180927.GA16055@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Mar 2018 15:47:55 -0700
Message-ID: <CAPcyv4gknYC3WUEEfGjNH8ufFvokdZarSaZUm-cczCXyEz_D0w@mail.gmail.com>
Subject: Re: [PATCH v7 05/14] ext4, dax: introduce ext4_dax_aops
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
To: Christoph Hellwig <hch@lst.de>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm <linux-nvdimm@lists.01.org>, david <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 29, 2018 at 11:09 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Thu, Mar 29, 2018 at 05:40:35PM +0200, Jan Kara wrote:
>> So ext4_direct_IO() for IS_DAX() files will just bail out. So could you
>> just provide ext4_dax_direct_IO() which will bail out and use it here? With
>> a similar comment as in xfs_vm_direct_IO() that open still needs this
>> method set... Thanks!
>
> In fact a common noop_direct_IO might make sense.

Ok, I introduced noop_direct_IO() in "fs, dax: prepare for
dax-specific address_space_operations", and cleaned up xfs, ext4, and
ext2 accordingly. Let me know if you want to see a resend of the
series with those changes. Otherwise this will appear in -next
shortly.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
