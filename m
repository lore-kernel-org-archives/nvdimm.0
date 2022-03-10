Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182E77A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 05:00:09 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id f8so4136937pfj.5
        for <nvdimm@lists.linux.dev>; Wed, 09 Mar 2022 21:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DmlaOnkXV7gYyLatHTSFHCOo07Z7E4KBwil1Hrfv+RU=;
        b=3EvzZ+84RIgKTLctT8/y9GJHmgVsI6b4yA09fCZK8D8rSU7jje0P3SaX7vJ5E6odJr
         LypsvJNqpS7Q9j7Et9R7THMRpBEZNkm6HdnWVdhQcDhOg/EWYxuHvg0yMvrSAJ3oNgX9
         1AAXNJzrcQRuPmBGUWaWTlmiCdmUx7620ZO/WC4V8L1k0omnYrTu+cxMc75J8FGBHo8E
         687a4KVAbdp0l+v8VfxpynWaW3387DvK1O+lryZHb2flExlJYVcOlhZbPfcZi6n3q84w
         YKp0ocBTueQ8x7IHZJ9XRirP1Z+iJhlTg7C46Y4ki4zeX2f4QXz0YWHC2r2C5V/nunJK
         nMBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DmlaOnkXV7gYyLatHTSFHCOo07Z7E4KBwil1Hrfv+RU=;
        b=R5E06Td0rcQdrb6TG3wkaqho+cXmFfC1Igg2QR1GryrKzoh1a9hnDhUdJg7/VxDj3h
         NrOrsWi5jeLo3T6FKCW3HMYN4x83HnNrYhUKTtccPWbH9OzaNxTwaW1Pl4i89CyjajSS
         TmQ/QYaIRkN5rVNAnz/aTEpCz61fT+dPk9P0rEgHT8A3OyojiJa/OPeR3yK3HrI5Yro5
         D4ZcXctIclwaqzZi2R7ISRQr9MOvRRd73yLcE4ROxIsyBUPm5LepYx/vA8ASSODqjQrM
         /dNBEzol+AaQJtXMGLBa2GCvKK9vkXqpxMfTI1Iz0HK1H0OwRhP5ozeVIr2iCwjhTV/2
         YQTg==
X-Gm-Message-State: AOAM532cGElq9T/hSKG3X3FVp/ssYhXYHXcEyXPiK3wcurpScrWAppBI
	9/2ev42MsEx1LAeAzRsEj5W3STv91zSUHGeWbXZxzg==
X-Google-Smtp-Source: ABdhPJxJ3M1uMJPPOfvSe4qNin9BErn7l9aDnJzi2AxsDSjcSEqvSkUiqDcMjN3WNNEuA4WH+wsk5FV8ARDID94jxD8=
X-Received: by 2002:a63:2a43:0:b0:376:4b9:f7e0 with SMTP id
 q64-20020a632a43000000b0037604b9f7e0mr2556716pgq.437.1646888408526; Wed, 09
 Mar 2022 21:00:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220225143024.47947-1-kjain@linux.ibm.com> <38ab9d45-e756-80b2-1b56-287c43c84ca2@linux.ibm.com>
In-Reply-To: <38ab9d45-e756-80b2-1b56-287c43c84ca2@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Mar 2022 20:59:57 -0800
Message-ID: <CAPcyv4ih7Ur_L_=Zce0h5CUSCr1MfqzNdo3-azygT_e9qgDB2g@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] Add perf interface to expose nvdimm
To: kajoljain <kjain@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Santosh Sivaraj <santosh@fossix.org>, maddy@linux.ibm.com, rnsastry@linux.ibm.com, 
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, atrajeev@linux.vnet.ibm.com, 
	Vaibhav Jain <vaibhav@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 7, 2022 at 9:27 PM kajoljain <kjain@linux.ibm.com> wrote:
>
> Hi Dan,
>     Can you take this patch-set if it looks fine to you.
>

Pushed out to my libnvdimm-pending branch for a 0day confirmation
before heading over to linux-next.
