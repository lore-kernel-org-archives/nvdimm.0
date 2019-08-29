Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com
 [IPv6:2607:f8b0:4864:20::332])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 420C32021DD44
 for <linux-nvdimm@lists.01.org>; Thu, 29 Aug 2019 11:30:33 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id g111so1343385otg.9
 for <linux-nvdimm@lists.01.org>; Thu, 29 Aug 2019 11:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190829001735.30289-1-vishal.l.verma@intel.com>
 <20190829001735.30289-4-vishal.l.verma@intel.com>
 <179261bd-9812-6bba-6710-19a77cf3acc6@oracle.com>
 <e343ace46d7243632eec594f679759fac78814ba.camel@intel.com>
In-Reply-To: <e343ace46d7243632eec594f679759fac78814ba.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Aug 2019 11:28:29 -0700
Message-ID: <CAPcyv4iQ8=yLGA0E2=puqV+mC7HxNW-RP-0EtVeU2hN6HsNxKQ@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/3] ndctl/namespace: add a --continue option to
 create namespaces greedily
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Scargall, Steve" <steve.scargall@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 29, 2019 at 11:08 AM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Thu, 2019-08-29 at 10:38 -0700, jane.chu@oracle.com wrote:
> > Hi, Vishal,
> >
> >
> > On 8/28/19 5:17 PM, Vishal Verma wrote:
> > > Add a --continue option to ndctl-create-namespaces to allow the creation
> > > of as many namespaces as possible, that meet the given filter
> > > restrictions.
> > >
> > > The creation loop will be aborted if a failure is encountered at any
> > > point.
> >
> > Just wondering what is the motivation behind providing this option?
>
> Hi Jane,
>
> See Steve's email here:
> https://lists.01.org/pipermail/linux-nvdimm/2019-August/023390.html
>
> Essentially it lets sysadmins create a simple, maximal configuration
> without everyone having to script it.

It also gives a touch point to start thinking about parallel namespace
creation. The large advancements in boot time that Alex achieved were
mainly from parallelizing namespace init. With --continue we could
batch the namespace enable calls and kick off a bind thread per
namespace.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
