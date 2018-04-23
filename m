Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 763A921E080E5
 for <linux-nvdimm@lists.01.org>; Mon, 23 Apr 2018 14:46:32 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH ndctl v2 2/3] Documentation: Add the support for
 asciidoctor
Date: Mon, 23 Apr 2018 21:46:28 +0000
Message-ID: <1524519985.20736.2.camel@intel.com>
References: <20180419151120.11041-1-tiwai@suse.de>
 <20180419151120.11041-3-tiwai@suse.de>
In-Reply-To: <20180419151120.11041-3-tiwai@suse.de>
Content-Language: en-US
Content-ID: <8E9B9468A8EB904B8704217212AE5A3E@intel.com>
MIME-Version: 1.0
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "tiwai@suse.de" <tiwai@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2018-04-19 at 17:11 +0200, Takashi Iwai wrote:
> This patch adds the support for asciidoctor to be used for generating
> documents instead of asciidoc.  It's enabled via --enable-asciidoctor
> configure option while asciidoc is used still as default.
> 
> In addition to the configure option, a few other changes were needed:
> * some asciidoc.conf python stuff has to be replaced with asciidoctor
>   ruby extension; copied mostly from git
> * asciidoctor requires slightly different options
> * the man pages are generated directly via asciidoctor without xmlto
>   processing; less package dependency
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  Documentation/asciidoctor-extensions.rb.in | 28
> ++++++++++++++++++++++++++++
>  Documentation/daxctl/Makefile.am           | 28
> ++++++++++++++++++++++++++--
>  Documentation/ndctl/Makefile.am            | 28
> ++++++++++++++++++++++++++--
>  configure.ac                               | 17 +++++++++++++++--
>  4 files changed, 95 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/asciidoctor-extensions.rb.in
> 
> diff --git a/Documentation/asciidoctor-extensions.rb.in
> b/Documentation/asciidoctor-extensions.rb.in
> new file mode 100644
> index 000000000000..ebdd665f1fb9
> --- /dev/null
> +++ b/Documentation/asciidoctor-extensions.rb.in
> @@ -0,0 +1,28 @@
> +require 'asciidoctor'
> +require 'asciidoctor/extensions'
> +
> +module @Utility@
> +  module Documentation
> +    class Link@Utility@Processor <
> Asciidoctor::Extensions::InlineMacroProcessor
> +      use_dsl
> +
> +      named :chrome
> +
> +      def process(parent, target, attrs)
> +        if parent.document.basebackend? 'html'
> +          prefix = parent.document.attr('@utility@-relative-html-
> prefix')
> +          %(<a
> href="#{prefix}#{target}.html">#{target}(#{attrs[1]})</a>\n)
> +        elsif parent.document.basebackend? 'docbook'
> +          "<citerefentry>\n" \
> +            "<refentrytitle>#{target}</refentrytitle>" \
> +            "<manvolnum>#{attrs[1]}</manvolnum>\n" \
> +          "</citerefentry>\n"
> +        end
> +      end
> +    end
> +  end
> +end
> +
> +Asciidoctor::Extensions.register do
> +  inline_macro @Utility@::Documentation::Link@Utility@Processor, :link@u
> tility@
> +end

Hi Takashi,

It looks like this extension should be doing the right thing for the
'linkndctl' macros, but for some reason it doesn't seem to be working for
me. In the generated man pages:

SEE ALSO
       linkndctl:ndctl-zero-labels[1], linkndctl:ndctl-init-labels[1]... etc.

Thanks,
	-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
