Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACB0F2256863D
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 13:59:58 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id a207so8091988oii.10
 for <linux-nvdimm@lists.01.org>; Fri, 09 Mar 2018 14:06:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d39d066f-4b12-8a90-08f6-6fd7737f74ba@gmail.com>
References: <152062242529.34816.8248756922497912006.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49y3j1ujh6.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gUHmfOgfstm3qaJqO7Mx38hba_T__y_4xrAcmbn_Lg1g@mail.gmail.com>
 <x49tvtpuikz.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iwbfobo4Dmq3nFvtcpiVVTdHEq=Nqf6asEft-QbuMemw@mail.gmail.com>
 <d39d066f-4b12-8a90-08f6-6fd7737f74ba@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Mar 2018 14:06:15 -0800
Message-ID: <CAPcyv4hmR7LqOuO33XP0xhwQixvMoYhpu=v079rJL=DF03Tuvw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, list: fix sector_size listing
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
To: Linda Knippers <ljklists@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 9, 2018 at 1:44 PM, Linda Knippers <ljklists@gmail.com> wrote:
[..]
>>> I think that, to the novice, seeing one namespace print out sector size
>>> and another not do the same, that would be confusing.  Also, you'd have
>>> to know what the default is.
>
> As a former ndctl user, I'm with Jeff.

The user is always right, v2 on the way.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
