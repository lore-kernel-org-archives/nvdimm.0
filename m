Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0054421A16E57
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 00:59:27 -0700 (PDT)
Date: Thu, 11 May 2017 09:59:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
Message-ID: <20170511075926.GC19837@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
 <20170510180214.16852-4-hch@lst.de>
 <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A@mail.gmail.com>
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
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 10, 2017 at 10:15:51PM +0300, Amir Goldstein wrote:
> > +static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
> >  {
> > -       return memcmp(&u1, &u2, sizeof(uuid_be));
> > +       return memcmp(&u1, &u2, sizeof(uuid_t));
> >  }
> >
> 
> 
> I think we should use this opportunity to change these to (uuid_t *, uuid_t *)
> which is more in line with the rest of the helpers including the new helpers
> hoisted from xfs.

Or just kill them off - uuid/guid_equals is the better interface for all
existing users as far as I can tell.  My updated series already kills
off the be/uuid one, the le/guid one will need a bit more work, though.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
