Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D3DF32119FF36
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 15:47:35 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id c206so344166oib.0
 for <linux-nvdimm@lists.01.org>; Tue, 22 Jan 2019 15:47:35 -0800 (PST)
MIME-Version: 1.0
References: <20190122220525.5211-1-elliott@hpe.com>
 <CAPcyv4gm8cP1gKddNuzQ_7jVW7sgfO=eMibR12ypnZ1qqQO1ZA@mail.gmail.com>
 <AT5PR8401MB11699BEE72425DFD16B50830AB980@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB11699BEE72425DFD16B50830AB980@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Jan 2019 15:47:24 -0800
Message-ID: <CAPcyv4he5ZKOwOSBW+p7A8PcaUxSpGJaBSdtPxwO+F9QWH9Log@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: normalize dev_debug failed and succeeded
 wording
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 22, 2019 at 3:13 PM Elliott, Robert (Persistent Memory)
<elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Dan Williams [mailto:dan.j.williams@intel.com]
> > Sent: Tuesday, January 22, 2019 4:24 PM
> > To: Elliott, Robert (Persistent Memory) <elliott@hpe.com>
> > Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
> > Subject: Re: [PATCH] libnvdimm: normalize dev_debug failed and succeeded wording
> >
> > Looks ok, just some formatting nits...
> >
> > On Tue, Jan 22, 2019 at 2:14 PM Robert Elliott <elliott@hpe.com> wrote:
> > >
> > >         if (rc < 0) {
> > >                 nvdimm_put_key(key);
> > >                 key = NULL;
> > > -       }
> > > +               dev_dbg(dev, "key: %d revalidation failed: %d\n",
> > > +                       key_serial(key), rc);
> > > +       } else
> > > +               dev_dbg(dev, "key: %d revalidation succeeded\n",
> > > +                       key_serial(key));
> >
> > For all of these success vs fail cases I would prefer to continue to
> > use a ternary:
> >
> >     dev_dbg(dev, "key: %d revalidation %s: %d\n",
> >         key_serial(key), rc == 0 ? "succeeded" : "failed", rc);
> >
> > ...as to not clutter the code with extra debug statements.
>
> That'll result in printing the return code for successful cases:
>     ...succeeded: 0
>
> I guess that's fine for the dev_dbg level.

Yeah, I'm ok with that price for slightly more compact code.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
