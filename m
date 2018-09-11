Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5372421A07A92
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 11:12:13 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH 1/2] ext4, dax: update dax check to skip journal inode
Date: Tue, 11 Sep 2018 18:11:39 +0000
Message-ID: <19388d015c54202ee3d1e8526677ccdf7d46cd02.camel@hpe.com>
References: <20180911154246.6844-1-toshi.kani@hpe.com>
 <20180911154246.6844-2-toshi.kani@hpe.com>
 <CAPcyv4j0zF+OjqPywkmZLgGiSjNdH_9SwpXjS=92bqT9OXZ_MQ@mail.gmail.com>
In-Reply-To: <CAPcyv4j0zF+OjqPywkmZLgGiSjNdH_9SwpXjS=92bqT9OXZ_MQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <4A8A9F59A15EEE4EB1D10A8094F9B84B@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "tytso@mit.edu" <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "jack@suse.cz" <jack@suse.cz>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-09-11 at 10:59 -0700, Dan Williams wrote:
> On Tue, Sep 11, 2018 at 8:42 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > Ext4 mount path calls ext4_iget() to obtain the journal inode.  This
> > inode does not support DAX, and 'ext4_da_aops' needs to be set.  It
> > currently works for the DAX mount case because ext4_iget() always set
> > 'ext4_da_aops' to any regular files.
> > 
> >   ext4_fill_super
> >     ext4_load_journal
> >       ext4_get_journal_inode
> >         ext4_iget
> > 
> > In preparation to fix ext4_iget() to set 'ext4_dax_aops' for DAX files,
> > update ext4_should_use_dax() to return false for the journal inode.
> > 
> > Fixes: 5f0663bb4a64f588f0a2dd6d1be68d40f9af0086
> 
> Just a minor format recommendation:
> 
> Fixes: 5f0663bb4a64 ("ext4, dax: introduce ext4_dax_aops")
> Cc: <stable@vger.kernel.org>

Will do.

> 
> This looks good to me.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Thanks!
-Toshi

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
