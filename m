Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5269021A6F108
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 12:15:52 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id b204so6095323oii.1
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 12:15:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170510180214.16852-4-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
 <20170510180214.16852-4-hch@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 10 May 2017 22:15:51 +0300
Message-ID: <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A@mail.gmail.com>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
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
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 10, 2017 at 9:02 PM, Christoph Hellwig <hch@lst.de> wrote:
> Our "little endian" UUID really is a Wintel GUID, so rename it and its
> helpers such (guid_t).  The big endian UUID is the only true one, so
> give it the name uuid_t.  The uuid_le and uuid_be names are retained for,
> but will hopefully go away soon.
>
> Also remove the existing typedef in XFS that's now been superceeded by
> the generic type name.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> [andy: also updated the UUID_LE/UUID_BE macros including fallout]
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
[...]

>
> -static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
> +static inline int guid_cmp(const guid_t u1, const guid_t u2)
>  {
> -       return memcmp(&u1, &u2, sizeof(uuid_le));
> +       return memcmp(&u1, &u2, sizeof(guid_t));
>  }
>
> -static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
> +static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
>  {
> -       return memcmp(&u1, &u2, sizeof(uuid_be));
> +       return memcmp(&u1, &u2, sizeof(uuid_t));
>  }
>


I think we should use this opportunity to change these to (uuid_t *, uuid_t *)
which is more in line with the rest of the helpers including the new helpers
hoisted from xfs.

[...]

> +/* backwards compatibility, don't use in new code */
> +#define uuid_le_cmp(u1, u2)    guid_cmp(u1, u2)
> +#define uuid_be_cmp(u1, u2)    uuid_cmp(u1, u2)

Therefore:
#define uuid_le_cmp(u1, u2)    guid_cmp(&(u1), &(u2))
#define uuid_be_cmp(u1, u2)    uuid_cmp(&(u1), &(u2))
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
