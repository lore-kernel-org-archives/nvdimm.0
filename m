Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7752C80
	for <nvdimm@lists.linux.dev>; Fri, 14 Jan 2022 22:48:08 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id v25so3891516pge.2
        for <nvdimm@lists.linux.dev>; Fri, 14 Jan 2022 14:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bbh9yc9OnBBCsyNMtewRPFcwLMZ/zT5pAXTX2uqKp6E=;
        b=2N+gAi8Eyyh1OYsmYzS19flf1xIZVuXNWRXKUWtSsyBPHqYXEQPZjtRYH348ipQWX0
         NjJ7hJ2lNyRD4uOHtcaNTC5IAF3nE1S/lpFYgLh3SjWs8dflIY902u6QnAdBmPOK3KV8
         aIr3unGhDFyDcRsggHttaP2K8w2VbeJiAMAfdCHT9zn9NIf4HJx5dXM58zGGZDNIpyX8
         IzD7Efy28lhIhCy1lwbXkxrmAJ0kst1MONnB9Qzg9nUnFW4YD9j8hHxdo1za6t8CI97O
         gAGPCxzGMe3Ek7g7lBUijiUvdDfHwzZ2AvRpy3PKq7ETCw0Nq4F1Y8iWzBi+ly/FjPNP
         ia6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bbh9yc9OnBBCsyNMtewRPFcwLMZ/zT5pAXTX2uqKp6E=;
        b=lNcB26HvTlocRxfcBZQ/kPiDhFRGjGQsNNzel78E9e2jdiX8ugZshvvWMkclCN0/KD
         PG/g15JTTOU6127fZVn8EQVtyqRbS2MKpxYH3PlvgvQJCuTxBa8EKUx9/S9To2PPJiOL
         nTlSJJHejhCG+Hnep4P4VcG/+rfF70h19asbLyjgyuolO1cT+r65kZYInvTeqMSIAKT/
         VmBtcZfVlt6a2sfFpvvnHC3YrEXXt6zPb9NNgU3HCGPU0TtZzHRAERB+eYCN3i5fcG34
         VRS4y6clb8MzgKotUMT5aDPaTXZVz0pAR7wUhVxoxckUooaSqzAKy893tlBF3X2DzNOw
         IbXw==
X-Gm-Message-State: AOAM531xnpzJbb5nr5PUmXApjrJKYtoTUd8GIrzOJZNJSGDFM9IwRIEl
	fygBiEkoKm6rZFhhfJxNWm1C4RTYpWqhZxlcBmpaUA==
X-Google-Smtp-Source: ABdhPJzPoZIBuoaUUI00ZUgK3B/CfFrD05XFj73lA9ZdsIu63rDQP1HReFNdEbHGBljecLAhVrof9ZtUfYvFkSU4DDs=
X-Received: by 2002:a63:79c2:: with SMTP id u185mr9995735pgc.74.1642200487958;
 Fri, 14 Jan 2022 14:48:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
 <d4a57facb2b778867e3bbe8564f03868b58e2f72.camel@intel.com> <c6be7804-419e-d547-062d-6b852494bceb@oracle.com>
In-Reply-To: <c6be7804-419e-d547-062d-6b852494bceb@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 14 Jan 2022 14:47:55 -0800
Message-ID: <CAPcyv4jYg3DRv6Eeq3s2c0kk4dSvr3_i_jk+Uc2Pew9FON+zmA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 00/16] ndctl: Meson support
To: Jane Chu <jane.chu@oracle.com>
Cc: "Verma, Vishal L" <vishal.l.verma@intel.com>, "jmoyer@redhat.com" <jmoyer@redhat.com>, 
	"msuchanek@suse.de" <msuchanek@suse.de>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "breno.leitao@gmail.com" <breno.leitao@gmail.com>, 
	"vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>, "kilobyte@angband.pl" <kilobyte@angband.pl>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jan 14, 2022 at 2:31 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Hi,
>
> Should the README.md file get updated accordingly?

Indeed! Will fix.
