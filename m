Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6672F27
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 21:09:49 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so4622012pjj.4
        for <nvdimm@lists.linux.dev>; Tue, 01 Feb 2022 13:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZfkXO1SmtkeMFUVSjvOQaqvQ+wHw5M7LGlS5Mzh9l6g=;
        b=kWlOYQrzrIg8Ucw66RplSgM6whdDw/Mz1z9iyt2dyGE/KJXUWZDi3iBQ1IKXcKGPLY
         qDKcWPSDgTz5z3XE+FiQrtW2QAJ4BArh/UzDO2LmvBgjGsi+VMnYRdL95Pwb4vJs5GVw
         8daSdqYv0u1sIlX/T5AnKtMxNycMy+zjC811VFW1JyNoHZHHmkkl7rz1Txv409pblJBA
         H96vayr1EQSaBvShBIt88oWYMT3aEx79xcQYxceVba7ss6eFNX0pNKe/wQnwJonv+8w1
         +v5yBpXqeQlg9FzQdbfniUiFnbCw17LVQUK6pA6ktJGWv5n4RKaB/aN/KrtR7WAYSVLn
         uePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZfkXO1SmtkeMFUVSjvOQaqvQ+wHw5M7LGlS5Mzh9l6g=;
        b=X5ZZqhnIK1fKQr4q7SbsKcZsUF51SHcgo1jd/3yEkA+WwvF2kx770pBw7lRmFhIREM
         jvpvopY892UmqO+xMVGId6We86ilTJ84sx4wzFSsBchkVEbSZJtleby/hOH/oLFe7fRM
         e45imd0Om/hAmOlh2K5Hs6YkI12DXbhAQ9xfxKIzvCiNBbeYSpdD8Jx+FQohEeqWkLZs
         3g6MWozVMWH+T5oZTrWECLI36i3ZG4+PCIovh+Uh10DzKqOsUAtHucIQt+fWJZF451eJ
         ENKncOgvfyl0y2rcupHBLCvhxMUppjXTt9OxgtxMZp7Qx3Z3RIYdJKaJ1HR7joSQ4EG2
         U7PA==
X-Gm-Message-State: AOAM530XAsroHBHiTQbXz6plznUAafexyV/OIH+hBKdIMcJ4gxK33oqW
	aVI5eRFyWk4kLW6YGVD/tIGke6ph+MfZ3LkatyA4/Q==
X-Google-Smtp-Source: ABdhPJwxrhpjOmKbpFy9646jr5PcqrEbt3VRXObtW3+qrnpZHuE5dGOHs+xgCzm77qFq0pYWb0bEuGnXcbI9Bwr8vAk=
X-Received: by 2002:a17:90b:3ece:: with SMTP id rm14mr226745pjb.220.1643749788965;
 Tue, 01 Feb 2022 13:09:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164298425201.3018233.647136583483232467.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220201151728.zgc55ckks672gedz@intel.com>
In-Reply-To: <20220201151728.zgc55ckks672gedz@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Feb 2022 13:09:42 -0800
Message-ID: <CAPcyv4hQ2BFWT7D45UYaL0JfTuSfpaAWbKdqLYsrbRYifre7HA@mail.gmail.com>
Subject: Re: [PATCH v3 25/40] cxl/core/port: Remove @host argument for dport +
 decoder enumeration
To: Ben Widawsky <ben.widawsky@intel.com>
Cc: linux-cxl@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 1, 2022 at 7:17 AM Ben Widawsky <ben.widawsky@intel.com> wrote:
>
> On 22-01-23 16:30:52, Dan Williams wrote:
> > Now that dport and decoder enumeration is centralized in the port
> > driver, the @host argument for these helpers can be made implicit. For
> > the root port the host is the port's uport device (ACPI0017 for
> > cxl_acpi), and for all other descendant ports the devm context is the
> > parent of @port.
> >
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> I really like removing @host as much as possible everywhere.

It's only possible where the parent device is the host.

> Reviewed-by: Ben Widawsky <ben.widawsky@intel.com>
