Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 392B721E47D72
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 09:22:33 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id t196so9914169oif.3
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 09:25:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170824160846.GA27591@lst.de>
References: <150353211413.5039.5228914877418362329.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170824160846.GA27591@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 09:25:07 -0700
Message-ID: <CAPcyv4iFLZCi=xMCQH+HOjnqZEPLOVUuPkcVCTS6V=8QGpP8ag@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] MAP_DIRECT and block-map-atomic files
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
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Airlie <airlied@linux.ie>, Linux API <linux-api@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Takashi Iwai <tiwai@suse.com>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Daniel Vetter <daniel.vetter@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 9:08 AM, Christoph Hellwig <hch@lst.de> wrote:
> This seems to be missing patches 1 and 3.

Sorry, I didn't cc you directly on those. They're on the list:

https://patchwork.kernel.org/patch/9918657/
https://patchwork.kernel.org/patch/9918663/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
