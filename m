Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B0AEC225E4027
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 16:38:27 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id 126-v6so2931301oig.0
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 16:44:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180322232741.GA29040@linux.intel.com>
References: <20180322184007.25667-1-ross.zwisler@linux.intel.com>
 <20180322184007.25667-2-ross.zwisler@linux.intel.com>
 <CAPcyv4hyx4zgdw4FH1Bpy6OPvjcy7Vv_axrQUtxazTc6vP8t+g@mail.gmail.com>
 <20180322232741.GA29040@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Mar 2018 16:44:58 -0700
Message-ID: <CAPcyv4ie2FPGesiChi+RgWSdEQgL_=4yTKj0j_Tgcx5Yj5Ntew@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/2] ndctl: fail NUMA filtering when unavailable
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 22, 2018 at 4:27 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Thu, Mar 22, 2018 at 03:47:01PM -0700, Dan Williams wrote:
>> On Thu, Mar 22, 2018 at 11:40 AM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> > Instead of just failing to find namespaces when trying to filter by NUMA
>> > node when CONFIG_NUMA wasn't enabled in the kernel, instead fail loudly as
>> > numactl does:
>> >
>> >   # numactl --cpunodebind=0 ls
>> >   numactl: This system does not support NUMA policy
>> >
>> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> > ---
>> >
>> > This enabling requires numactl to create a pkg-config file, which it
>> > currently does not.  This support is added by the following patch which
>> > I just sent out:
>> >
>> > https://patchwork.kernel.org/patch/10302135/
>>
>> Hmm, it's going to be a while for that to be picked up and filter out
>> into all the distributions so we can either wait for the next numactl
>> release to become commonly available, or rework this ndctl change to
>> be independent of pkgconfig dependency.
>
> Sure - I'm not yet sure how to do that. :)  Any tips on how to check for
> library dependencies without pgk-config support?

The AC_CHECK_LIB() autoconf macro is the place to start.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
