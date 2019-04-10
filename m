Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D47CC2194D3AE
 for <linux-nvdimm@lists.01.org>; Wed, 10 Apr 2019 01:38:34 -0700 (PDT)
Date: Wed, 10 Apr 2019 04:38:33 -0400 (EDT)
From: Pankaj Gupta <pagupta@redhat.com>
Message-ID: <1336073020.20708683.1554885513376.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190410082804.GG1426@quack2.suse.cz>
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-4-pagupta@redhat.com>
 <20190410082804.GG1426@quack2.suse.cz>
Subject: Re: [PATCH v5 3/6] libnvdimm: add dax_dev sync flag
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
To: Jan Kara <jack@suse.cz>
Cc: cohuck@redhat.com, kvm@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org, adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org, aarcange@redhat.com, linux-nvdimm@lists.01.org, david@redhat.com, willy@infradead.org, hch@infradead.org, linux-acpi@vger.kernel.org, linux-ext4@vger.kernel.org, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>, stefanha@redhat.com, pbonzini@redhat.com, lcapitulino@redhat.com, kwolf@redhat.com, nilal@redhat.com, tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>, darrick wong <darrick.wong@oracle.com>, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>


> 
> On Wed 10-04-19 09:38:23, Pankaj Gupta wrote:
> > @@ -64,6 +65,10 @@ static inline bool dax_write_cache_enabled(struct
> > dax_device *dax_dev)
> >  {
> >  	return false;
> >  }
> > +static inline bool dax_synchronous(struct dax_device *dax_dev)
> > +{
> > +	return true;
> > +}
> 
> Is there a need to define dax_synchronous() for !CONFIG_DAX? Because that
> property of dax device is pretty much undefined and I don't see anything
> needing to call it for !CONFIG_DAX...

You are right. Will remove this.

Thanks for the review.

Best regards,
Pankaj

> 
> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
