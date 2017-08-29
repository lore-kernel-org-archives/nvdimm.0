Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B90B2095B9F5
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 14:28:47 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id w10so37849534oie.1
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 14:31:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170829212606.GC8608@lst.de>
References: <150389211501.25151.6477753201827914462.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150389212075.25151.17146973298430877023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170829212606.GC8608@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 14:31:27 -0700
Message-ID: <CAPcyv4hA_vkSdZowaJ78FPCOhY2Z_iORX0B63=_RCCGdqack_g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] fs, xfs: perform dax_device lookup at mount
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 29, 2017 at 2:26 PM, Christoph Hellwig <hch@lst.de> wrote:
> Call me nitpicky, but..
>
> First this really should be three patches, one for the DAX code, one
> for the VFS code and one for XFS.  The DAX and XFS bits looks fine to
> me:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> But I'm a little worried about stuffing more DAX knowledge into the
> block mount_bdev helper.  For now it's probably ok as everything
> else would involve a lot of refactoring and/or duplication, but
> I'm generally not too happy about it.

I think this is why we ended up with calling dax_get_by_host() in
->iomap_begin() because the mount_bdev() touches I started with back
when this was first introduced were not very palatable. I agree with
the direction to move to mount_dax() in the future. I can respin this
into three patches and a TODO comment about how we want to kill the
dax knowledge in mount_bdev() going forward.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
