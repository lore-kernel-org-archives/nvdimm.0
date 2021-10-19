Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEFB72
	for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 17:54:10 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id z24so704084qtv.9
        for <nvdimm@lists.linux.dev>; Tue, 19 Oct 2021 10:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=k4EO566ZbpDs//uEG0jbVR7BFdP1GfXfmKzfi4PdmWw=;
        b=HB4JP5njikOn5AfAjstCyQb2U7X3CujnisIyXaASRNun6gILVZvON+Yk48mBRHPRQR
         RY1+sRlgsr4BKrj236S0iTZsTOsNkkZjZ77O+6H/cvjckutVQZ3lo8RY8U232+LTDoYD
         wrihaSgZz2EistaLinuluW7+Nf7Q1gmULkotO5by0ezt3trLunAM+NZd9jcsJb3f3Wi4
         z9wh4z0QqPvbnullfeEX1bvb04TiS8B3jP4X5b6vkUqhm2JFdw/xlnQqiRMTT8tECovZ
         H5OJfA5xdR7xDlsP6Q3ZnFWs3v7A5Erau3MMcunjF2p/JVcC2lBzQ800djcevSsut0s3
         fsqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k4EO566ZbpDs//uEG0jbVR7BFdP1GfXfmKzfi4PdmWw=;
        b=VYIug0znZwNxu7m109VEr7WtPmyu8KJCdOsCJbOQqRWEyE651cSWFZUTZgiij4TMIB
         RW58Q7u4Ux/qShjno6SK8hIlkOUK/6gOar3z3x45MtvZsI/x/B81lZe/LxegngnBU/mN
         K73qf+7GLXDCX501uC1L+sdR/H00Bw7nLFDnHKiKDmO2KruLFIsAAXvIRGGuvyqWEPYX
         rwbXm/lQ1J3dmpcK7j/e02+ybhx9zTLBirZeR1Z1FwO405FS0fNBqvluZ9kHgHOzwemy
         q65wFFHRzsWSw3cGDreie8xuirTPztOvo9KRTT5wJ06b0Vh6G07S2yhIzqbl4BPFI3VM
         FnFQ==
X-Gm-Message-State: AOAM530+mlg/s05icOdoguOwEDRHc5pX4k0aLFYxa9cYC2ezk38QUSN+
	JwdQZGDZyQJVmemdy6U3vcNryw==
X-Google-Smtp-Source: ABdhPJz54D+TH75Ir6oqy79nFFUrYbmeO/WH3eSFZrTLNjPikl0roL2ySe8DOGvYpxXiO4sh+slelQ==
X-Received: by 2002:ac8:74c7:: with SMTP id j7mr1578684qtr.118.1634666049948;
        Tue, 19 Oct 2021 10:54:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id u189sm8144732qkh.14.2021.10.19.10.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 10:54:09 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
	(envelope-from <jgg@ziepe.ca>)
	id 1mctJQ-00GuaZ-PR; Tue, 19 Oct 2021 14:54:08 -0300
Date: Tue, 19 Oct 2021 14:54:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Alex Sierra <alex.sierra@amd.com>,
	"Kuehling, Felix" <Felix.Kuehling@amd.com>,
	Linux MM <linux-mm@kvack.org>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
Message-ID: <20211019175408.GJ3686969@ziepe.ca>
References: <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com>
 <CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
 <20210824202449.19d524b5@thinkpad>
 <CAPcyv4iFeVDVPn6uc=aKsyUvkiu3-fK-N16iJVZQ3N8oT00hWA@mail.gmail.com>
 <20211014230439.GA3592864@nvidia.com>
 <5ca908e3-b4ad-dfef-d75f-75073d4165f7@oracle.com>
 <20211018233045.GQ2744544@nvidia.com>
 <CAPcyv4i=Rsv3nNTH9LTc2BwCoMyDU639vdd9kVEzZXvuSY+dWA@mail.gmail.com>
 <20211019142032.GT2744544@nvidia.com>
 <CAPcyv4jAQVSKB7rts5Mfu0JRtB-b1NGFgu03+8-ja8o11d1vQA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jAQVSKB7rts5Mfu0JRtB-b1NGFgu03+8-ja8o11d1vQA@mail.gmail.com>

On Tue, Oct 19, 2021 at 10:38:42AM -0700, Dan Williams wrote:

> > So we can just delete the detection of the page size and rely on the
> > zap code to wipe out the entire level, not split it. Which is what we
> > have today already.
> 
> As Joao points out, userspace wants to know the blast radius of the
> unmap for historical reasons. I do think it's worth deprecating that
> somehow... providing a better error management interface is part of
> the DAX-reflink enabling.

OK, it makes sense.

I have a less invasive idea though - emulate what zap is doing:

      if (!pud_present(*pud))
               return 0;
      if (pud_leaf(*pud))
             return PUD_SHIFT;

      if (!pmd_present(*pud))
               return 0;
      if (pmd_leaf(*pud))
             return PMD_SHIFT;
      return PAGE_SHIFT;

Which would return the "blast radius" of the unmap_mapping_range()
when it rounds up to the left page level that contains the VA.

Now it doesn't need the pte_devmap test..

And when both DAX's learn to use compound_head this can be deleted.

Jason
