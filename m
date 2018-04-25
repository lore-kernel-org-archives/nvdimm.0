Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x236.google.com (mail-ot0-x236.google.com
 [IPv6:2607:f8b0:4003:c0f::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B21262041B281
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 00:32:53 -0700 (PDT)
Received: by mail-ot0-x236.google.com with SMTP id y10-v6so11262227otg.10
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 00:32:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0DEDF3B159719A448A49EF0E7B11E3222764EEE1@g01jpexmbkw01>
References: <20180418063242.9221-1-qi.fuli@jp.fujitsu.com>
 <CAPcyv4gb0JVRtW8QQy_TkJyZmpteGveOgzAPt66Otx0sftyrHw@mail.gmail.com>
 <1524067583.6010.7.camel@intel.com>
 <0DEDF3B159719A448A49EF0E7B11E3222764E26B@g01jpexmbkw01>
 <0DEDF3B159719A448A49EF0E7B11E3222764EEE1@g01jpexmbkw01>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Apr 2018 00:32:52 -0700
Message-ID: <CAPcyv4h_Ddu5uWfJkbu2-KQZ4ChQi-uL=VH5k8y=LVX=7518ow@mail.gmail.com>
Subject: Re: [PATCH v2] ndctl, filter: refacor util_<obj>_filter() to support
 multiple space-seperated arguments
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 24, 2018 at 7:39 PM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
> When I ran the command # ndctl list --dimm="all nmem1 nmem2", I found
> only "nmem1" and "nmem2" can be listed, the keyword "all" was ignored.
> I want to confirm is this result expected?
> If not, I will make a follow up patch to fix this bug.

Yes, good catch, that's a bug.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
