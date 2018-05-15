Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22d.google.com (mail-ot0-x22d.google.com
 [IPv6:2607:f8b0:4003:c0f::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 08A4A209603C4
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 10:33:52 -0700 (PDT)
Received: by mail-ot0-x22d.google.com with SMTP id m11-v6so1158255otf.3
 for <linux-nvdimm@lists.01.org>; Tue, 15 May 2018 10:33:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5AFAD1FA02000078001C2DFD@prv1-mh.provo.novell.com>
References: <dc4870bd-d227-e425-5ada-96d36e232a9a@citrix.com>
 <d1f6fded-7131-3215-9fc0-36f6acf2bf41@citrix.com>
 <CAPcyv4h2P8wYrrghYPz+DuD-34zhmHAOFBLSKeoJPtYa8q43ng@mail.gmail.com>
 <20180515100557.ea2airy4isbn2yzq@MacBook-Pro-de-Roger.local>
 <83A27BAE-E3A3-45FD-B595-714BE1F839E8@citrix.com>
 <5AFAD1FA02000078001C2DFD@prv1-mh.provo.novell.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 May 2018 10:33:51 -0700
Message-ID: <CAPcyv4h3R6o9nAVzU62E1gUL4Zgn1aLAbeo_2tOb5oPd7MH6kw@mail.gmail.com>
Subject: Re: Draft NVDIMM proposal
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
To: Jan Beulich <JBeulich@suse.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Cooper <andrew.cooper3@citrix.com>, George Dunlap <george.dunlap@citrix.com>, xen-devel@lists.xen.org, Roger Pau Monne <roger.pau@citrix.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 15, 2018 at 5:26 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 15.05.18 at 12:12, <George.Dunlap@citrix.com> wrote:
[..]
>> That is, each fsdax / devdax namespace has a superblock that, in part,
>> defines what parts are used for Linux and what parts are used for data.  Or
>> to put it a different way: Linux decides which parts of a namespace to use
>> for page structures, and writes it down in the metadata starting in the first
>> page of the namespace.
>
> And that metadata layout is agreed upon between all OS vendors?

The only agreed upon metadata layouts across all OS vendors are the
ones that are specified in UEFI. We typically only need inter-OS and
UEFI compatibility for booting and other pre-OS accesses. For Linux
"raw" and "sector" mode namespaces defined by namespace labels are
inter-OS compatible while "fsdax", "devdax", and so called
"label-less" configurations are not.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
