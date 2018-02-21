Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7881C2034D8EF
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 15:51:00 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id a207so2459718oii.10
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 15:57:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1519252098.24924.23.camel@intel.com>
References: <151925075889.65338.1771943064286480835.stgit@djiang5-desk3.ch.intel.com>
 <151925076435.65338.5271742129529173494.stgit@djiang5-desk3.ch.intel.com>
 <1519252098.24924.23.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Feb 2018 15:56:59 -0800
Message-ID: <CAPcyv4jUPddTPvZhKXjV54xLgWKdOFm5Jvzff5bbvwT0q2gggg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ndctl: add "all" dimm-id option for update-firmware
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

On Wed, Feb 21, 2018 at 2:28 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Wed, 2018-02-21 at 15:06 -0700, Dave Jiang wrote:
>> Adding all option to allow ndctl to update all DIMMs at once.
>
> I was going to ask that we should also update the documentation for
> this command to include the new 'all' behavior, but it looks like
> during the revisions of the original series, the documentation update
> to list the options explicitly got dropped?
>
> Anyway, can you re-add those, and also talk about --dimm=all there.
>
> On a side note, should we make this more inline with other dimm
> commands, such as xable-dimm or read/write-labels, where the dimm name
> (or 'all') is a non-option argument? That would make it something like:
>
>   ndctl update-firmware --firmware=<file> nmem0 (or 'all)

Sounds good to me, but we should still silently support -d for just
this command since it appeared in a released version and user
interfaces are forever.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
