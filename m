Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22f.google.com (mail-ot0-x22f.google.com
 [IPv6:2607:f8b0:4003:c0f::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8DF2821A143DA
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 18:57:09 -0700 (PDT)
Received: by mail-ot0-x22f.google.com with SMTP id a2so46627877oth.2
 for <linux-nvdimm@lists.01.org>; Fri, 09 Jun 2017 18:58:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jntkch6nReSFMJ5uMxjwHFGzOB2mFzGurz1u4aOoCP3w@mail.gmail.com>
References: <1497026071-46879-1-git-send-email-linda.knippers@hpe.com>
 <CAPcyv4grYufA9mUfApWVb3d0nnZ6GdO408PnSFk0uaAs7RO8Mw@mail.gmail.com>
 <34325df2-3c43-faaa-fa66-23d46782cf32@hpe.com>
 <CAPcyv4jaSGS49a-NiOOKLbo5z7gYHuzbug2aMrx41E1C4F8+LA@mail.gmail.com>
 <23e2d0fe-105a-f102-8155-5324ee8de576@hpe.com>
 <CAPcyv4jUcwNNX3hCijo+u4mC7L5_1Rjbuf5dk5c+CiJ8sYAOMQ@mail.gmail.com>
 <a035bfc8-f8a5-4d0b-46e7-a1298f8a1bb2@hpe.com>
 <CAPcyv4jntkch6nReSFMJ5uMxjwHFGzOB2mFzGurz1u4aOoCP3w@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jun 2017 18:58:19 -0700
Message-ID: <CAA9_cmfLJ1OtCGbHSHvHVe2naJDkU3uiv1_OV2A6hDaja_M1eQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] Report the Health Status Detail for the HPE1 DSM
 family
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 9, 2017 at 1:46 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Jun 9, 2017 at 12:52 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>> If you try to combine the two, it's not clear what state you're getting
>> because it's not obvious from ndctl whether it's static or dynamic data.
>> I believe that's why you correctly didn't call the state flags "health"
>> data.
>
> True, ok, we do already have the distinction that the "health"
> sub-object is live data. So how about a middle ground? For the live
> detail flags that indicate the similar data as the static health-state
> flags from the NFIT let call them the same name. So it would look like
> this:
>
>            {
>              "dev":"nmem0",
>              "health":{
>                "flag_failed_arm":true,
>              }
>            }
>
> Where a monitor application can see that we started with the DIMM
> armed and it went unarmed, but it only ever needs to worry about one
> key name for the "armed" state.

...and to be clear the reverse case (failed at boot, but later becomes
armed) would look like this:

           {
             "dev":"nmem0",
             "flag_failed_arm":true,
             "health":{
               "flag_failed_arm":false,
             }
           }

Where, we need to emit the updated flag in the live "health" case
because it is now different than the boot state.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
