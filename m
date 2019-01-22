Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B9ED62063E305
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 15:13:08 -0800 (PST)
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
 by mx0b-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x0MN19np009986
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 23:13:07 GMT
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 by mx0b-002e3701.pphosted.com with ESMTP id 2q68k51sg2-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 23:13:07 +0000
Received: from G9W8456.americas.hpqcorp.net (g9w8456.houston.hp.com
 [16.216.161.95])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2352.austin.hpe.com (Postfix) with ESMTPS id BF9619B
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 23:13:06 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] libnvdimm: normalize dev_debug failed and succeeded
 wording
Date: Tue, 22 Jan 2019 23:13:05 +0000
Message-ID: <AT5PR8401MB11699BEE72425DFD16B50830AB980@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190122220525.5211-1-elliott@hpe.com>
 <CAPcyv4gm8cP1gKddNuzQ_7jVW7sgfO=eMibR12ypnZ1qqQO1ZA@mail.gmail.com>
In-Reply-To: <CAPcyv4gm8cP1gKddNuzQ_7jVW7sgfO=eMibR12ypnZ1qqQO1ZA@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Dan Williams [mailto:dan.j.williams@intel.com]
> Sent: Tuesday, January 22, 2019 4:24 PM
> To: Elliott, Robert (Persistent Memory) <elliott@hpe.com>
> Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
> Subject: Re: [PATCH] libnvdimm: normalize dev_debug failed and succeeded wording
> 
> Looks ok, just some formatting nits...
> 
> On Tue, Jan 22, 2019 at 2:14 PM Robert Elliott <elliott@hpe.com> wrote:
> >
> >         if (rc < 0) {
> >                 nvdimm_put_key(key);
> >                 key = NULL;
> > -       }
> > +               dev_dbg(dev, "key: %d revalidation failed: %d\n",
> > +                       key_serial(key), rc);
> > +       } else
> > +               dev_dbg(dev, "key: %d revalidation succeeded\n",
> > +                       key_serial(key));
> 
> For all of these success vs fail cases I would prefer to continue to
> use a ternary:
> 
>     dev_dbg(dev, "key: %d revalidation %s: %d\n",
>         key_serial(key), rc == 0 ? "succeeded" : "failed", rc);
> 
> ...as to not clutter the code with extra debug statements.

That'll result in printing the return code for successful cases:
    ...succeeded: 0

I guess that's fine for the dev_dbg level.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
