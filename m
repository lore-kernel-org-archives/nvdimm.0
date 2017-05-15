Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E4C421A1349E
 for <linux-nvdimm@lists.01.org>; Mon, 15 May 2017 10:48:22 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id l18so139918393oig.2
 for <linux-nvdimm@lists.01.org>; Mon, 15 May 2017 10:48:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170515154308.26739-9-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de>
 <20170515154308.26739-9-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 May 2017 10:48:21 -0700
Message-ID: <CAPcyv4hzosqta=KcAHs08MAMrzgEt0CbAHTZMZ9d+jh3ymeWFA@mail.gmail.com>
Subject: Re: [PATCH 08/17] uuid: hoist uuid_is_null() helper from libnvdimm
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
Cc: linux-xfs@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Amir Goldstein <amir73il@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 15, 2017 at 8:42 AM, Christoph Hellwig <hch@lst.de> wrote:
> Hoist the libnvdimm helper as an inline helper to linux/uuid.h
> using an auxiliary const variable uuid_null in lib/uuid.c.
>
> [hch: also add the guid variant.  Both do the same but I'd like
> to keep casts to a minimum]
>
> The common helper uses the new abstract type uuid_t * instead of
> u8 *.
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> [hch: added guid_is_null]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
