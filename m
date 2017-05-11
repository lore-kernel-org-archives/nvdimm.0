Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8143121A0BA9C
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 01:31:41 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id w10so3032164oif.1
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 01:31:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170511075926.GC19837@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
 <20170510180214.16852-4-hch@lst.de>
 <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A@mail.gmail.com>
 <20170511075926.GC19837@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 11 May 2017 11:31:40 +0300
Message-ID: <CAOQ4uxg0xRNw_pVipXqt_qpNm58uzp+VLYTcwMVypmmZZ-ztcg@mail.gmail.com>
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

On Thu, May 11, 2017 at 10:59 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, May 10, 2017 at 10:15:51PM +0300, Amir Goldstein wrote:
>> > +static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
>> >  {
>> > -       return memcmp(&u1, &u2, sizeof(uuid_be));
>> > +       return memcmp(&u1, &u2, sizeof(uuid_t));
>> >  }
>> >
>>
>>
>> I think we should use this opportunity to change these to (uuid_t *, uuid_t *)
>> which is more in line with the rest of the helpers including the new helpers
>> hoisted from xfs.
>
> Or just kill them off - uuid/guid_equals is the better interface for all
> existing users as far as I can tell.  My updated series already kills
> off the be/uuid one, the le/guid one will need a bit more work, though.

That works too. and for another argument, why need a helper uuid/guid_cmp
when one can use C comparison (i.e. u1 != u2) ? assuming that we have no
reason to abstract that fact that uuid_t/guid_t are a struct type.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
