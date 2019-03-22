Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 851F8211E8300
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 15:21:59 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id d24so3273506otl.11
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 15:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <155183603979.191625.11689546261255336448.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155183605525.191625.7383205178321396418.stgit@dwillia2-desk3.amr.corp.intel.com>
 <32fe21cd06ec2e1a3add9235511e6ac536efcda9.camel@intel.com>
In-Reply-To: <32fe21cd06ec2e1a3add9235511e6ac536efcda9.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Mar 2019 15:21:47 -0700
Message-ID: <CAPcyv4ieCpkQ=GjP2Et7jePfM30Oq6dv5rSvH7vhge+yBx6TFg@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/5] ndctl/dimm: Add offset and size options to
 {read, write, zero}-labels
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 22, 2019 at 2:49 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
>
> On Tue, 2019-03-05 at 17:34 -0800, Dan Williams wrote:
> > Allow for more precision in label utilities, i.e. stop operating over
> > the entire label area.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  Documentation/ndctl/labels-options.txt |    9 ++++++
> >  ndctl/dimm.c                           |   45 ++++++++++++++++++++++++--------
> >  ndctl/lib/dimm.c                       |   36 +++++++++++++++++++++-----
> >  ndctl/lib/libndctl.sym                 |    2 +
> >  ndctl/lib/private.h                    |    3 --
> >  ndctl/libndctl.h                       |    4 +++
> >  util/util.h                            |    4 +++
> >  7 files changed, 83 insertions(+), 20 deletions(-)
> >
>
> [..]
>
> > diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
> > index 5a17f0b63b80..1304017d5e3b 100644
> > --- a/ndctl/lib/private.h
> > +++ b/ndctl/lib/private.h
> > @@ -241,9 +241,6 @@ struct ndctl_namespace {
> >   *
> >   * A command may only specify one of @source, or @iter.total_buf, not both.
> >   */
> > -enum {
> > -     READ, WRITE,
> > -};
>
> This fails to build as libndctl.c now needs to include util/util.h..
> Stale version perhaps? (Patch 4 in the series also fails to apply
> cleanly)

Hmm, ok I'll resend. It probably depends on something in the
read-infoblock patch that needs to be fixed up.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
