Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x232.google.com (mail-ot0-x232.google.com
 [IPv6:2607:f8b0:4003:c0f::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37A0081FFD
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jan 2017 09:12:16 -0800 (PST)
Received: by mail-ot0-x232.google.com with SMTP id f9so247000842otd.1
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jan 2017 09:12:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170130122817.GC9043@lst.de>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148559256970.11180.2541041546993320141.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170130122817.GC9043@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 30 Jan 2017 09:12:14 -0800
Message-ID: <CAPcyv4jx433Y1As=GjpjYcLVLBHyJvXtTdrs-kmo_K4pkKfzGQ@mail.gmail.com>
Subject: Re: [RFC PATCH 01/17] dax: refactor dax-fs into a generic provider of
 dax inodes
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
Cc: Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 30, 2017 at 4:28 AM, Christoph Hellwig <hch@lst.de> wrote:
> I really don't like the dax_inode name.  Why not something like
> dax_device or dax_region?

Fair enough, I'll switch struct dax_inode to dax_device and switch the
existing struct dax_dev to dax_info.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
