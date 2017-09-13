Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D9FD21E8796F
 for <Linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 12:47:35 -0700 (PDT)
Date: Wed, 13 Sep 2017 13:50:26 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: DAX enabled. Warning: EXPERIMENTAL, use at your own risk
Message-ID: <20170913195026.GA26069@linux.intel.com>
References: <83993302.1433078.1505327170801.ref@mail.yahoo.com>
 <83993302.1433078.1505327170801@mail.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <83993302.1433078.1505327170801@mail.yahoo.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Soccer Liu <soccer_liu@yahoo.com>
Cc: "Linux-nvdimm@lists.01.org" <Linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 13, 2017 at 06:26:10PM +0000, Soccer Liu wrote:
>  =

> Hi:
> During my debugging, I kept seeing this message from the DAX enabled mount
> operation.
> =

> [=A0=A0=A0 0.757990] EXT4-fs (pmem0): DAX enabled. Warning: EXPERIMENTAL,=
 use at your own risk
> =

> I am wondering how far this DAX feature is still away from becoming a
> "non-experimental" feature.=A0(Another way of asking my questions: are th=
ere
> any major issues that's blocking it?)

We talked about this a bit as a group during my LSF/MM talk this year:

https://lwn.net/Articles/717953/

Essentially the consensus was that we need to make the XFS and ext4 mount
options consistent and get reflink + DAX in a better state.  We also probab=
ly
figure out the per-DAX inode issues that have recently been under discussio=
n:

https://lkml.org/lkml/2017/9/6/529

There will always be work to do, but I think those are the things that are
standing between us and removing the EXPERIMENTAL warning.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
