Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5135417E3
	for <nvdimm@lists.linux.dev>; Tue,  6 Dec 2022 19:03:56 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id y17so14868579plp.3
        for <nvdimm@lists.linux.dev>; Tue, 06 Dec 2022 11:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XKfLhtZZQiN5pSiAeJTX5xqJtW3KLq/JfbNtylyUaJU=;
        b=VxnAxNgGOgsXpsaU7ZA9OwLdwRP+hxmrx+La/sML6JnsAqnSN846KtCP7QFgZdJ7k2
         XrzPinRPiVGRjSDOVdRhfhxpGaUW+acW8edifKFVjXwabtoXz8j7/QRvhJBeKtbH1RC6
         WPtdttADxBJqD0yAtMP+Z9te/jOg+mvO9JSWk83VdxwdqKJTYfEwFFzh6AqH87cEIrhb
         SQcW32Jkn3X1pNwyNGSCZIui3qg+5J5d4i5ptIlRRZvPC1DUaxVbB46T6UO3kLSsAK/T
         Zxa3ub9vZcoxF0qKrtE5Kx2XSOvsuks6WIZul7fEtjeooWMb9ztBzipdeGp4t/fL1kFW
         YVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XKfLhtZZQiN5pSiAeJTX5xqJtW3KLq/JfbNtylyUaJU=;
        b=ZbZnoW+wYxB7HcSadOEYR8urwyDb0Xedr4DPXMMJL85Nmv4qcTvm8vI9+CGp3vguty
         5T8aTgGsJs3zYyupGlZDQROI6snpYb2/ZbV4QCJI46R4v0Hd4s0caQakgddi/S2SKSPg
         eqYyCbWODbIDmnPsAasVRzo7ELWbgbrWT+DfFy/UQjf1H5FSIY+yix+cgDMytjw7G5tw
         5ifcyo3a7Eh77vYtriVNrJE7a+JMPUZ1th1bBSz+Iepg3sJRyM32o/1gSYcT6lDyS1OG
         pdzsAjbLw1KEMgV9Zi8WU5nO+T2ZjGtIsTu8rxLuJKGSuSpzvtlNcfFWgi3rNp6GMHwB
         LNOA==
X-Gm-Message-State: ANoB5pnR883Pgvn8NpcX8m84ZQCuoHQww3qEes5X17c17olGEqFsTerm
	PGsgRvYYLJdUDvOFuMmn0NRLAznL1A9yuCDHYsLKJA==
X-Google-Smtp-Source: AA0mqf5d3mlBVbzJKV3LClOVBUQgCRRqs0aWQXsM3lcVZ7urMWklFHSAKQKM1YAMovSKjvk0q/ONrVCIg3KZXXH1oQw=
X-Received: by 2002:a17:902:d346:b0:189:efa1:2953 with SMTP id
 l6-20020a170902d34600b00189efa12953mr2486379plk.97.1670353435620; Tue, 06 Dec
 2022 11:03:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221115214036.1571015-1-sammler@google.com>
In-Reply-To: <20221115214036.1571015-1-sammler@google.com>
From: Michael Sammler <sammler@google.com>
Date: Tue, 6 Dec 2022 11:03:44 -0800
Message-ID: <CAFPP518x6cg97tK_Gm-qqj9htoydsBtYm5jbG_KivK5rfLcHtA@mail.gmail.com>
Subject: Re: [PATCH v2] virtio_pmem: populate numa information
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mina Almasry <almasrymina@google.com>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Michael Sammler <mich.sammler@gmail.com>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>
Content-Type: text/plain; charset="UTF-8"

This patch is reviewed and tested. Is there anything that needs to be
done from my side (e.g. sync with mainline)?

(Adding my alternative email address to this thread as I will soon
lose access to the address I am sending this email from.)
