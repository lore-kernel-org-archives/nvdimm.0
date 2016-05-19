Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sandeen.net (sandeen.net [63.231.237.45])
 by ml01.01.org (Postfix) with ESMTP id 7FB791A1DF7
 for <linux-nvdimm@lists.01.org>; Thu, 19 May 2016 16:37:20 -0700 (PDT)
Subject: Re: [PATCH v4 0/6] Add alignment check for DAX mount
References: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f265e4ce-9271-1d83-35bc-794f2e2129df@sandeen.net>
Date: Thu, 19 May 2016 18:37:12 -0500
MIME-Version: 1.0
In-Reply-To: <1462897437-16626-1-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>, dan.j.williams@intel.com, jack@suse.cz, david@fromorbit.com, viro@zeniv.linux.org.uk
Cc: hch@infradead.org, tytso@mit.edu, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 5/10/16 11:23 AM, Toshi Kani wrote:
> When a partition is not aligned by 4KB, mount -o dax succeeds,

Sorry for being late, but -

Shouldn't this and all subsequent patch commits refer to
PAGE_SIZE, rather than "4kB?"

-Eric

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
