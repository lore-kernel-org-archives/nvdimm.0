Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
 <1557417933-15701-2-git-send-email-larry.bassel@oracle.com> <AT5PR8401MB116928031D52A318F04A2819AB0C0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR8401MB116928031D52A318F04A2819AB0C0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 May 2019 11:14:07 -0700
Message-ID: <CAPcyv4juGEo=sMX01YuqPY9oYDjBjmRp7GvreNnX8YvKQz=SjA@mail.gmail.com>
Subject: Re: [PATCH, RFC 1/2] Add config option to enable FS/DAX PMD sharing
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: Larry Bassel <larry.bassel@oracle.com>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, "willy@infradead.org" <willy@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 10, 2019 at 9:32 AM Elliott, Robert (Servers)
<elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Linux-nvdimm <linux-nvdimm-bounces@lists.01.org> On Behalf Of
> > Larry Bassel
> > Sent: Thursday, May 09, 2019 11:06 AM
> > Subject: [PATCH, RFC 1/2] Add config option to enable FS/DAX PMD
> > sharing
> >
> > If enabled, sharing of FS/DAX PMDs will be attempted.
> >
> ...
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> ...
> >
> > +config MAY_SHARE_FSDAX_PMD
> > +def_bool y
> > +
>
> Is a config option really necessary - is there any reason to
> not choose to do this?

Agree. Either the arch implementation supports it or it doesn't, I
don't see a need for any further configuration flexibility. Seems
ARCH_WANT_HUGE_PMD_SHARE should be renamed ARCH_HAS_HUGE_PMD_SHARE and
then auto-enable it.
