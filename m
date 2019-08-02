Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 495A021306CFF
 for <linux-nvdimm@lists.01.org>; Fri,  2 Aug 2019 11:21:53 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id c15so2103868oic.3
 for <linux-nvdimm@lists.01.org>; Fri, 02 Aug 2019 11:19:23 -0700 (PDT)
MIME-Version: 1.0
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156426356654.531577.6142389862764297120.stgit@dwillia2-desk3.amr.corp.intel.com>
 <c6026e16692b0aae2b8fdef1085940259d40de93.camel@intel.com>
In-Reply-To: <c6026e16692b0aae2b8fdef1085940259d40de93.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 2 Aug 2019 11:19:11 -0700
Message-ID: <CAPcyv4h5YWF5hrX+B5iJrW95K03TFA+a2rsQPFtG=PqN8WgigQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 01/26] ndctl/dimm: Add 'flags' field to
 read-labels output
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

On Fri, Aug 2, 2019 at 11:01 AM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
>
> On Sat, 2019-07-27 at 14:39 -0700, Dan Williams wrote:
> > Recent discussions on some platform implementations setting the LOCAL
> > bit in namespace labels makes it apparent that this field should be
> > decoded in the json representation.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  ndctl/dimm.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> > index b2b09b6aa9a2..8946dc74fe41 100644
> > --- a/ndctl/dimm.c
> > +++ b/ndctl/dimm.c
> > @@ -141,6 +141,11 @@ static struct json_object *dump_label_json(struct ndctl_dimm *dimm,
> >                       break;
> >               json_object_object_add(jlabel, "nlabel", jobj);
> >
> > +             jobj = json_object_new_int64(le64_to_cpu(nslabel.flags));
>
> Should we print this in hex instead?

Ah, yes.

/me goes to check why he didn't do this finds that this support
arrives in the next patch that adds --human support to read-labels.

So it's there in "ndctl/dimm: Add --human support to read-labels"
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
